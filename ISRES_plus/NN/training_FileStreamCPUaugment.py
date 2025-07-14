#%%
import os
import numpy as np
import tensorflow as tf
from tensorflow import keras
import pandas as pd


#%% 
# Specifications
#
sys_folder      = '../'
folderletter    = 'C'
imagetype       = 'CrossSections'
modelname       = '1'

nBatchVal       = 10
nBatchTrain     = 100


#%%
# folder names from specifications
#
if folderletter=='A':
    base_folder = sys_folder + 'A_20repeats_21-holdout/'
    img_folder  = sys_folder + '20_repeats/' 
elif folderletter == 'B':
    base_folder = sys_folder + 'B_20repeats_29-holdout/'
    img_folder  = sys_folder + '20_repeats/' 
elif folderletter == 'AB':
    base_folder = sys_folder + 'AB_20repeats_21-29-holdout/'
    img_folder  = sys_folder + '20_repeats/' 
elif folderletter == 'C':
    base_folder = sys_folder + 'C_100repeats_16-32-holdout/'
    img_folder  = sys_folder + '100_repeats/' 
elif folderletter == 'D':
    base_folder = sys_folder + 'D_100repeats_11-13-holdout/'
    img_folder  = sys_folder + '100_repeats/' 
img_folder      = img_folder  + 'Images/' + imagetype + '/'
csv_folder      = base_folder + 'csvfiles/'
checkpoint_path = base_folder + 'Models/' + imagetype + '_' + folderletter + modelname
train_csv       = csv_folder  + imagetype + '_' + folderletter + '_train.csv'
val_csv         = csv_folder  + imagetype + '_' + folderletter + '_val.csv'
#tf.config.run_functions_eagerly(True)

#tf.config.run_functions_eagerly(True)



#%%
# Make training and validation dataframes
#
df         = pd.read_csv(train_csv)
filenames  = img_folder + df["filename"].values
id         = df["id"].values
ds_train   = tf.data.Dataset.from_tensor_slices((filenames, id))
df         = pd.read_csv(val_csv)
filenames  = img_folder + df["filename"].values
id         = df["id"].values
ds_val     = tf.data.Dataset.from_tensor_slices((filenames, id))

def read_image(image_file, label):
    image = tf.io.read_file(image_file)
    image = tf.image.decode_image(image,channels=1, dtype=tf.float32)
    #print(image.shape + 'read_image')
    return image, label

def augment(image,label):
    #print(image.shape)
    #target_height, target_width, numch  = image.shape
    target_height = 128
    target_width  = 128 
    image         = tf.image.random_crop(image, [target_height,target_width,1])
    if np.random.rand(1):
        if np.random.rand(1):
            image = tf.image.random_flip_left_right(image)
        if np.random.rand(1):
            image = tf.image.random_flip_up_down(image)
        if np.random.rand(1):
            if np.random.rand(1):
                gammaval = (2-0.5)*np.random.rand(1) + 0.5
                image = tf.image.adjust_gamma(image,gamma=gammaval,gain=1.1)
            if np.random.rand(1):
                c = tf.image.random_brightness(image, 1)
            if np.random.rand(1):
                c = tf.image.random_contrast(image, 0.25,1.1)   
    #print(image.shape)         
    return image,label



AUTOTUNE = tf.data.experimental.AUTOTUNE
ds_train = ds_train.map(read_image,num_parallel_calls=AUTOTUNE).cache().shuffle(1000,reshuffle_each_iteration=True).prefetch(AUTOTUNE).batch(nBatchTrain)
ds_val   = ds_val.map(read_image,num_parallel_calls=AUTOTUNE).cache().shuffle(1000,reshuffle_each_iteration=True).prefetch(AUTOTUNE).batch(nBatchVal)

#ds_train = ds_train.map(read_image).map(augment).batch(2)
#ds_val   = ds_val.map(read_image).map(augment).batch(2)



#%%
# Make Model
#

dim = 150
model = tf.keras.models.Sequential([
    tf.keras.layers.Conv2D(250, (2,2),activation='relu', input_shape=(150,150,1)),
    tf.keras.layers.BatchNormalization(),

    tf.keras.layers.Conv2D(250, (2,2),activation='relu'),
    tf.keras.layers.BatchNormalization(),
    tf.keras.layers.Dropout(0.1),
    tf.keras.layers.MaxPooling2D(2,2),

    tf.keras.layers.Conv2D(250, (2,2),activation='relu'),
    tf.keras.layers.BatchNormalization(),

    tf.keras.layers.Conv2D(250, (2,2),activation='relu'),
    tf.keras.layers.BatchNormalization(),
    tf.keras.layers.Dropout(0.1),
    tf.keras.layers.MaxPooling2D(2,2),

    # Flatten
    tf.keras.layers.Flatten(), 
    tf.keras.layers.Dense(32, activation='relu'), 
    tf.keras.layers.Dropout(0.10),
    tf.keras.layers.Dense(32, activation='relu'), 
    tf.keras.layers.Dropout(0.10),
    tf.keras.layers.Dense(32, activation='relu'), 
    tf.keras.layers.Dropout(0.10),
    tf.keras.layers.Dense(32, activation='relu'), 
    tf.keras.layers.Dropout(0.10),

    # Output
    tf.keras.layers.Dense(1)
])
model.summary()




#%%
# Set checkpoint path and compile
#
cp_callback     = tf.keras.callbacks.ModelCheckpoint(checkpoint_path, save_best_only=True, verbose=2, save_freq='epoch')
model.compile(loss='mean_squared_error', optimizer = tf.keras.optimizers.Adam(learning_rate=0.001), metrics = ['mse'])



#%%
# Train
#
history = model.fit(ds_train, validation_data=ds_val, verbose=2, epochs=1000,callbacks=[cp_callback])

