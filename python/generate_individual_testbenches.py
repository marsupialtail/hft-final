import numpy as np
import sys


def dec_to_2s(number, width):
	if number > 0:
		result = bin(number) 
		pad_l = width - (len(result) - 2)
		if pad_l < 0:
			return "Error not enough bits"
		else:
			return "0" * pad_l + result[2:]
	elif number == 0:
		return "0" * width
	else:
		return dec_to_2s(number + 2 ** width, width)

def generate_overall_test(N=4):
	command = "matrix[I][J] <= 16'bB;"
	a = np.random.randint(2**14,size=(N,N)) - 2**13
	b = np.ones(N) * 2 **13
	for i in range(N):
		for j in range(N):
			print command.replace("I",str(i)).replace("J",str(j)).replace("B",dec_to_2s(a[i,j],16))

	[q,r] = np.linalg.qr(a)
	ref = np.linalg.solve(a,b)
	result = "result[I][J] = B"

	for i in range(N):
		for j in range(i,N):
			#print result.replace("I",str(i)).replace("J",str(j)).replace("B",dec_to_2s(int(r[i,j]),16))
			print result.replace("I",str(i)).replace("J",str(j)).replace("B",hex(int(dec_to_2s(int(r[i,j]),16),2)))
	for i in range(N):
		for j in range(i,N):
			#print result.replace("I",str(i)).replace("J",str(j)).replace("B",dec_to_2s(int(r[i,j]),16))
			print result.replace("I",str(i)).replace("J",str(j)).replace("B",hex(int(dec_to_2s(int(-r[i,j]),16),2)))
	for i in range(N):
		print int(ref[i] * 2 ** 8)
		print hex(int(dec_to_2s(int(ref[i] * 2 ** 8),16),2))


def generate_qr_test(N=4):
	command = "matrix[I][J] <= 16'bB;"
	a = np.random.randint(2**14,size=(N,N)) - 2**13
	for i in range(N):
		for j in range(N):
			print command.replace("I",str(i)).replace("J",str(j)).replace("B",dec_to_2s(a[i,j],16))

	[q,r] = np.linalg.qr(a)

	result = "result[I][J] = B"

	for i in range(N):
		for j in range(i,N):
			#print result.replace("I",str(i)).replace("J",str(j)).replace("B",dec_to_2s(int(r[i,j]),16))
			print result.replace("I",str(i)).replace("J",str(j)).replace("B",hex(int(dec_to_2s(int(r[i,j]),16),2)))
	for i in range(N):
		for j in range(i,N):
			#print result.replace("I",str(i)).replace("J",str(j)).replace("B",dec_to_2s(int(r[i,j]),16))
			print result.replace("I",str(i)).replace("J",str(j)).replace("B",hex(int(dec_to_2s(int(-r[i,j]),16),2)))

def generate_solver_test(N=4):
	a = np.random.randint(2**14,size=(N,N)) - 2**13
	a = np.triu(a)
	b = np.random.randint(2**14,size=(N,)) - 2**13
	ref = np.linalg.solve(a,b)
	print(a / 2.0 ** 13)
	print(b / 2.0 **13)
	command = "r[I][J] <= 16'bB;"
	for i in range(N):
		for j in range(i, N):
			print command.replace("I",str(i)).replace("J",str(j)).replace("B",dec_to_2s(a[i,j],16))
		print command.replace("I",str(i)).replace("J",str(N)).replace("B",dec_to_2s(b[i],16))

	for i in range(N):
		print hex(int(dec_to_2s(int(ref[i] * 2 ** 8),16),2))
	for i in range(N):
		print hex(int(dec_to_2s(int(ref[i] * 2 ** 7),16),2))


def generate_cov_test(N=4,T=4.0):
	old_moment = np.random.normal(size=(N,N))
	old_mean = np.random.normal(size=(N))
	old_p = np.random.normal(size=(N))
	new_p = np.random.normal(size=(N))

	returns = (new_p - old_p) / old_p
	factor = T / (T+1)
	new_mean = factor * old_mean + returns / (T+1)
	new_moment = np.outer(returns,returns) / (T+1) + factor * old_moment
	new_cov = new_moment - np.outer(new_mean,new_mean)

	command = "old_moment[I][J] = V * 2 **8;"
	for i in range(N):
		for j in range(N):
			print command.replace("I",str(i)).replace("J",str(j)).replace("V",str(old_moment[i,j]))
	command = "old_mean[I] = V * 2 ** 8;"
	for i in range(N):
		print command.replace("I",str(i)).replace("V",str(old_mean[i]))
	command = "old_p[I] = V * 2 ** 8;"
	for i in range(N):
		print command.replace("I",str(i)).replace("V",str(old_p[i]))
	command = "new_p[I] = V * 2 ** 8;"
	for i in range(N):
		print command.replace("I",str(i)).replace("V",str(new_p[i]))

	print new_mean
	print new_moment
	print new_cov
	print factor
	

#generate_qr_test()
#generate_solver_test()
generate_overall_test()
#generate_cov_test()
			
