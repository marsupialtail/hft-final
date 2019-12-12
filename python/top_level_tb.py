#!/usr/bin/env python
# coding: utf-8

import time
import numpy as np

temp = np.random.normal(size=(4,4))
gold_cov_matrix = np.dot(temp,temp.transpose()) / 250
gold_mean = [0.001,0.0015,0.002,0.003]

# generate covariance matrix
np.random.multivariate_normal(mean=gold_mean,cov=gold_cov_matrix)

# set target from actual covariance matrix
gold_target = np.linalg.solve(gold_cov_matrix,np.ones(4))
gold_target = gold_target / np.sum(gold_target)


# generate price path
N = 50
prices = np.zeros((N,4))
# initialize starting prices
prices[0,:] = [100,40,50,60]
mean_ret = np.zeros(4)
asset = [1]
for i in range(N-1):
    ret = np.random.multivariate_normal(mean=gold_mean,cov=gold_cov_matrix)
    asset.append( asset[-1] + np.dot(gold_target,ret))
    prices[i+1,:] = np.minimum(prices[i,:] * (1+ret),127) 
    mean_ret += ret

# see sample mean return, compare that to the gold_mean
print(mean_ret / N)


# start estimation process
old_moment = np.zeros((4,4))
old_mean = np.zeros(4)
positions = np.ones(4) / 4
est_asset = [1]

times = []

for i in range(1,50):
   
    # flush cache before benchmarking
    a = np.dot(np.random.normal(siez=(100,100)),np.random.normal(size=(100,10000)))
    start = time.time()
    old_p = prices[i-1,:]
    new_p = prices[i,:]
    returns = (new_p - old_p) / old_p

    # estimation from one observation of prices
    factor = i / (i+1)
    new_mean = factor * old_mean + returns / (i+1)
    new_moment = np.outer(returns,returns) / (i+1) + factor * old_moment
    new_cov = new_moment - np.outer(new_mean,new_mean)
    
    old_moment = new_moment
    old_mean = new_mean
    
    #est_asset.append(est_asset[-1] + np.dot(returns,positions))
   
    # solve for the target positions 
    [q,r] = np.linalg.qr(new_cov)
    #print("new mean:", new_mean)
    #print("new moment:", new_moment)
    #print("q:",q)
    #print("r:",r)
    #print("solve:",np.dot(q.transpose(),np.ones(4)))
    #print(new_cov)

    try:
      target = np.linalg.solve(r,np.dot(q.transpose(),np.ones(4)))
    except:
      target = np.array([1,1,1,1])
    positions = target / np.sum(target)

    end = time.time()
    times.append(end-start)
    print("positions: ",positions)
    

print("CPU runtime:", np.mean(times))
print(new_cov)
print(gold_cov_matrix)


# print verilog for test bench
price_stmt = "price <= '{A*2**8,B*2**8,C*2**8,D*2**8};\n#3000;\n"
for i in range(50):
	print(price_stmt.replace("A",str(prices[i,0])).replace("B",str(prices[i,1])).replace("C",str(prices[i,2])).replace("D",str(prices[i,3])))
