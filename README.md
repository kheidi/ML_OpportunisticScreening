# ML_OpportunisticScreening
Creating a ML framework to use Opportunistic Cardiometabolic Screening data to predict outcomes.

## Project description
This project will challenge you to use the tools learnt on this course (and ideally others) to analyze a real dataset related to Opportunistic Cardiometabolic Screening. The main idea is to exploit data collected for a specific purpose, and use it for an alternative purpose. For example, using a thoracic X-ray that was collected to treat a broken rib to predict an osteoporotic fracture later on. Specifically, your goal is to predict clinical outcomes (e.g., death, Alzheimer’s, or cancer) using incidental data that typically goes unused/underuse – this includes clinical data and computerized tomography (CT) data.

## Goals
Use and compare at least two methods from this class for the following purposes:
- Predict adverse clinical outcomes using CT data. The main outcome, which you must include in your predictions, is death. All other outcomes are optional but highly encouraged.
- Explore how predictions improve when we use Clinical data in addition to CT data.
- Derive a patient’s biological age (i.e., relative to actual chronological age) using CT data. (The date of the CT scan is day zero, and all other dates are now in days relative to the date of CT).

# How to Run
1. Pull the repo to your personal machine
2. Convert the data from an .xlsx to a .csv and ensure that the file is named: OppScrData.csv
3. Copy the OppScrData.csv file into any folder in the local repo.
4. Run the file titled runMe.m
5. Run either cleanData() or balancedData.m depending if you would like to work with the balanced or unbalanced data.
6. Run the scripts found in the 'scripts' folder at your leisure to generate the different machine learning models and generate the estimates.
