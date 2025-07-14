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
slno            = 'slno21'
imagetype       = 'NLSquared'
folderletter    = 'AB'
modelname       = '3'

nBatch          = 1


#%%
# folder names from specifications
#
base_folder     = sys_folder + 'zTestCode/'
img_folder      = sys_folder + '0repeats/Images/' + imagetype + '/'
csv_folder      = sys_folder + '0repeats/csvfiles/' + imagetype + '_' + slno + '.csv'
checkpoint_path = base_folder + 'Models2/' + imagetype + '_' + folderletter + modelname



#%%
# Make training and validation dataframes
#
df         = pd.read_csv(csv_folder)
filenames  = img_folder + df.iloc[:,0]
id         = df.iloc[:,1]
ds_test    = tf.data.Dataset.from_tensor_slices((filenames, id))

def read_image(image_file, label):
    image = tf.io.read_file(image_file)
    image = tf.image.decode_image(image,channels=1, dtype=tf.float32)
    #print(image.shape + 'read_image')
    return image, label

ds_test  = ds_test.map(read_image).batch(nBatch)



#%%
# Load Model
#
checkpoint_path = './Models2/' + imagetype + '_' + folderletter + modelname
model = tf.keras.models.load_model(checkpoint_path)



# %%
# TESTING
#
# Evaluate model on test data ot get loss and accuracy
loss, acc = model.evaluate(ds_test, verbose=2)

# make predictions using this model
y_test_pred = model.predict(ds_test)



#%%
# Make plots
#
import matplotlib.pyplot as plt
y_test = id

i0 = np.argsort(y_test)
plt.plot(y_test[i0],label='test')
plt.plot(y_test_pred[i0],label='predicted')
plt.legend(['Actual','Predicted'])
#plt.title(checkpoint_path + img_folder)
plt.ylim((0,1))



# %%
