import math
import numpy as np
import matplotlib.pyplot as plt


def calc_loss(h_list, param_batch):
    rows = np.shape(param_batch)[0]
    loss_batch = np.zeros((rows, 1))
    for r in range(rows):
        gamma = param_batch[r, 0]
        h_inf = param_batch[r, 1]
        loss = 0
        for ih in range(0, 4):
            hn = h_list[ih]
            hn_1 = h_list[ih + 1]
            h_fit = hn + (-gamma) * ((hn - h_inf) ** 3)
            loss += (hn_1 - h_fit) ** 2
        loss_batch[r, 0] = loss
    return loss_batch


def locate_min_loss(loss_batch):
    rows = np.shape(loss_batch)[0]
    loss_min = math.inf
    idx = -1
    for r in range(rows):
        loss = loss_batch[r, 0]
        if loss < loss_min:
            loss_min = loss
            idx = r
    return idx


def fit_by_anneal(h_list, param, epoch, batch):
    param_list = np.zeros((epoch, 2))
    loss_list = np.zeros((epoch, 1))

    for i in range(epoch):
        # random normal
        rand_batch = np.random.normal(size=(batch, 2))
        # calc random param (avg = last_param, sigma = last_step)
        # sigma_weight_fix = np.exp(-epoch / 10)
        sigma_weight_fix = 10 / epoch
        if i == 0:
            param_last = param[0, :]
            param_sigma = param[0, :]
        else:
            param_last = param_list[i - 1, :]
            param_sigma = (param_list[i, :] - param_list[i - 1, :]) * sigma_weight_fix
        param_batch = np.zeros((batch, 2))
        for ii in range(2):
            param_batch[:, ii] = param_sigma[ii] * rand_batch[:, ii] + param_last[ii]
        # calc loss
        loss_batch = calc_loss(h_list, param_batch)
        # locate min loss
        idx = locate_min_loss(loss_batch)
        # record
        param = param_batch[idx, :]
        loss = loss_batch[idx, :]
        param_list[i, :] = param_batch[idx, :]
        loss_list[i, :] = loss_batch[idx, :]
    print("result:")
    print(param)
    print(loss)
    return param_list, loss_list


def fit_main(h_list, param0):
    print("value:")
    print(h_list)
    print("start iterate:")
    print(param0)
    param = np.zeros((1, 2))
    param[0, 0] = param0[0]
    param[0, 1] = param0[1]
    param_list, loss_list = fit_by_anneal(h_list, param, epoch=1000, batch=100)
    fig = plt.figure()
    plt.subplot(2, 2, 1)
    plt.title('gamma')
    plt.plot(param_list[:, 0])
    plt.subplot(2, 2, 2)
    plt.title('h_inf')
    plt.plot(param_list[:, 1])
    plt.subplot(2, 2, 3)
    plt.title('loss')
    plt.plot(loss_list[:, 0])
    plt.show()


def main():
    # h_list = [11.93, 11.49, 11.38, 11.27, 11.23]
    # param = [2, 11]
    h_list = [
        0.87585,
        0.79484,
        0.78929,
        0.77894,
        0.78]
    param = [2, 0.7]
    fit_main(h_list, param)


if __name__ == '__main__':
    main()

