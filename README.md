# AlgoTrading-Robot
With the aim of self-learned education, I delved into the creation of my own AlgoTrading Robot. In this project, while I would study the basics of trading principles and strategies, my goal was to create a fully functional and autonomous trading robot in my local machine. In what follows, I discuss the steps I took to achieve this. Note that I used a Mac High Sierra 10.13.6 for this project.

### Architecture of the project
#### The Algorithm
The conceptual mechanics of the robot are layed out below. The data will be loaded from the yfinance module, which gets the data from Yahoo Finance. The online broker chosen for this project was Alpaca, due to its well documented API and ease of use.

1. Choose a few assets in the market to follow. This can be arbitrary, or select a few assets every few months based on some backtesting performance measure. This is discussed further below.
2. Choose the time interval to look at the data and perform actions. Again, this can be arbitrary or set based on some backtesting perfomance measure.
3. At a certain frequency, matching the chosen time interval, the algorithm should load the new closing price of the selected assets as soon as its available.
4. The new data is then analyzed and a buy, sell or continue signal is generated after defining a trading strategy in another function.
5. If the signal is buy or sell, the algorithm connects with the online broker through its API and places a market order.
6. Throughout this process, log entries are generated on a log file to keep track of the actions performed and for troubleshooting.

#### The Deployment
Ideally, the whole algorithm would have been deployed using some cloud solutions or a Raspberry Pi. However, I decided to maintain the project cost-free, thus deciding to find a patchwork solution on my local machine. Nonetheless, this is done in such manner only because the project is mainly educational and being well aware the risks and downsides of this solution.

The idea is that the robot should be completely autonomous, meaning that it should wake up at the start of the market day, perform the required actions throughout the day and turn off at the end of it, without my input, logging into the computer or else. To achieve this I did the following.

1. Set my computer to wake up and go to sleep at market opening and closing, respectively.
2. Create a bash script and put it into my LaunchDaemons, which continuously runs the script in the background without needing to log in. If it's the market opening time, it will disable the automatic sleep of my computer, so it stays on and running. If the time of day is within market hours, the bash script runs the python script containing the trading algorithm, which may perfom some actions. Otherwise, it goes to sleep to save the computer of continuously running the bash script. At market closing time, it re-activates the sleep of my computer, so it is able to shut down.
3. Putting a sleeping element in the bash script created an issue. If I was using my computer and it went to sleep for a period of time, and I then put my computer to sleep because I am done using it, the sleep timer pauses and continues with the automatic wake of my computer. Since the script if sleeping still, it does not deactivate the automatic sleeping of the computer, which turns off after a few seconds. Thus rose the need of a second bash script to keep running in the background as well, whose sole task is to kill the sleep timer of the original bash script if the time of day is that of the computer wake time. In summary, the computer wakes up a bit before market opening, bash script 2 kills the sleep of bash script 1, and then bash script 1 disables the automatic computer sleep and runs the trading algorithm for the remaining of the market day.
4. Lastly, because I need user permissions (give a password) every time I run a sleep disabeling command, I had to grant permission to these commands in my sudeors file.

While I learned a lot about bash scripting and terminal use, this is far from the ideal solution. Here, I depend on a proper wifi connection without issues, and for the computer to automatically turn on, it needs to be connected to a charging point. Meaning, if I forget to leave the charging on, go on a trip, or leave the house with the laptop and so forth, the computer will not wake up and miss a few hours of market time, which may be critical if it misses a sell signal. Ideally, the algorithm should be deployed in the cloud, without any local dependancy on my computer or environment.

#### Additional Feautures
1. Above it was mentioned that some arbitrary choices could be more educated, rather than randomly chosen. In particular, after building a backtesting function, it was easy to perform a grid search for the best performing market sector, the best performing assets of a few of the best performing sectors and the optimal time interval given a specific trading strategy. In so doing, I select the top three to five assets of the best three sectors every two months, and track those assets to apply the trading strategy.
2. Additionally, some functions and implementations were put in place to log everything the algorithm is doing, keep track of the portfolio's performance, compute the return of investment, send a monthly email with the results and so on, perfom a market study every two months and so on. Everything fully automated without any of my input.

### Results 
Finally, after managing the correct functioning of the algorithm and syncronization of the different scripts, it was time to put it to work and perform a forward testing, meaning that no real money is used, only fake paper but on the real market. Given the simplicity of the employed strategy, the results were, unsurprisingly, far from ideal, with negative returns in fact. Nevertheless, positive returns were not the objective and the learning I gained from this project were broad and satisfactory, as everything work as intended in the end. Many more ideas and features were available to implement but I decided to stop the project here and explore new topics and projects.
