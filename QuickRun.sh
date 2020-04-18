#!/bin/bash
cd Server
love . & > ../Server.log
cd ../Client
love . & > ../Client1.log
love . &> ../Client2.log