import numpy as np

def sin(x):
    return np.sin(x)

def cos(x):
    return np.cos(x)

def exp(x):
    return np.exp(x)

def noise(x):
    gaussian_noise = np.random.normal(np.mean(x), np.std(x))
    return x + gaussian_noise

def z_score(x):
    return (x - np.mean(x)) / np.std(x)

def log(x):
    return np.log(x)

