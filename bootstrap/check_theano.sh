#!/bin/bash

echo
echo '------------------'
echo 'TESTING THEANO CPU'
echo '------------------'
THEANO_FLAGS=mode=FAST_RUN,device=cpu,floatX=float32 python check_theano.py

echo
echo '------------------'
echo 'TESTING THEANO GPU'
echo '------------------'
THEANO_FLAGS=mode=FAST_RUN,device=gpu,floatX=float32 python check_theano.py

echo
