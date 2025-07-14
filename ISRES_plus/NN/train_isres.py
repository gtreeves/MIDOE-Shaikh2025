#%%
import os
import numpy as np
import tensorflow as tf
from tensorflow import keras
import pandas as pd
from tensorflow import keras
from tensorflow.keras import layers


#%%
# folder names from specifications
#
main_folder = './'
Xfile = main_folder + 'Xtrain.csv'
Ffile = main_folder + 'Ftrain.csv'
nBatch = 10


#%%
# Make training and validation dataframes
#
X = pd.read_csv(Xfile)
F = pd.read_csv(Ffile)

df = tf.data.Dataset.from_tensor_slices((X, F))
df  = df.batch(nBatch)


#%%
model = keras.Sequential([
      layers.Dense(64, activation='relu'),
      layers.Dense(64, activation='relu'),
      layers.Dense(64, activation='relu'),
      layers.Dense(64, activation='relu'),
      layers.Dense(64, activation='relu'),
      layers.Dense(64, activation='relu'),
      layers.Dense(64, activation='relu'),
      layers.Dense(64, activation='relu'),
      layers.Dense(1)
  ])



# %%
checkpoint_path = main_folder + 'Model1'
cp_callback     = tf.keras.callbacks.ModelCheckpoint(checkpoint_path, save_best_only=True, verbose=2, save_freq='epoch')
model.compile(loss='mean_squared_error', optimizer = tf.keras.optimizers.Adam(learning_rate=0.001), metrics = ['mse'])


#%%
history = model.fit(X,F, verbose=2, epochs=10,callbacks=[cp_callback],validation_split = 0.2)


# %%
