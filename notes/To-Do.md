# To-do
- Should we leave diagnoses as 0 or 1, or try to extract additional info from categories? For example take comments as categories - a good one for this would be cancer location.
- Decide how to deal with missing values:
	- Some methods (https://towardsdatascience.com/7-ways-to-handle-missing-values-in-machine-learning-1a6326adf79e):
		- Delete all rows with missing data for training
		- Continuous variables: replace NaN with mean
		- Categories: replace NaN with mode or with new variable "unknown"
		- The k-NN algorithm can ignore a column from a distance measure when a value is missing. Naive Bayes can also support missing values when making a prediction.
		- Another algorithm that can be used here is RandomForest that works well on non-linear and categorical data. It adapts to the data structure taking into consideration the high variance or the bias, producing better results on large datasets.
		- Use ML to predict:
			- **y_train**: rows from data["Age"] with non null values  
			- **y_test**: rows from data["Age"] with null values  
			- **X_train**: Dataset except data["Age"] features with non null values  
			- **X_test**: Dataset except data["Age"] features with null values
- Idea: wonder if there is a threshold of how long ago something was diagnosed?
- Idea: just run a total black box on data to see what happens, what is best ML method for this? Maybe normalize columns? but not transform dates into anything.

