# Bright_TV_Case_Study
Bright TV case study to improve viewership for company

**BrightTV Viewership Analytics**

BrightTV ‘s CEO has an objective to grow the company’s subscription base for this financial year. He has approached you to provide insights that would assist CVM (Customer Value
Management) team in meeting this year’s objective.
The dataset attached contains information on the user profiles and viewer transactions for BrightTV.

Please prepare a 20 min presentation covering the following topics:
• Provide insights on user and usage trends of BrightTV.
• What type of factors influence consumption?
• What content would you recommend to increase consumption on the days with low consumption?
• What type of initiatives would you recommend to further grow BrightTV ‘s User base.

Notes:
• Times and dates in the dataset are supplied in UTC and should be converted to SA time.
• Consumption is split per session, i.e. for every session a subscriber has, there will be 1 record.
• Any additional data that may assist in the presentation is welcomed


**Tools and Steps**
- Miro
- Excel
- Databricks
- Powerpoint
- Claude
  
**Planning Phase**
<img width="980" height="618" alt="image" src="https://github.com/user-attachments/assets/5b721883-cd6e-4774-967a-6c6c1650ae8d" />
<img width="951" height="543" alt="image" src="https://github.com/user-attachments/assets/c9bfb88f-0d7a-47f3-bdf6-b28a4e1aa087" />
<img width="954" height="232" alt="image" src="https://github.com/user-attachments/assets/25ff8b28-5c15-4831-adf2-f20fc8cb3ceb" />
<img width="963" height="456" alt="image" src="https://github.com/user-attachments/assets/06e3a9fa-4efc-478e-ba8f-7ef982e0ea70" />


<img width="491" height="639" alt="Screenshot 2026-04-19 132600" src="https://github.com/user-attachments/assets/99a84193-f9b3-4c68-a969-01c68d8ddcd5" />

**Process**
1. Check excel csv file and check the kind of data being used and the columns we have to identify key information columns. 2 sheets/tables, split into 2 separate excel file tables. Explore data columns given based on the
   Objectives.
2. ETL Phase
   - Upload two tables into Workspace Database, Created schema for Bright TV and add two tables.
   - Created GIT folders and Pushed to Github for version control and backup for team collaboration and transparency.
3. Used LEFT JOIN and Viewership table as Left table as not all columns are relevant from User_Profile table.
4. Checked for NULL Values
    - used IS NOT NULL
    - had to replace empty spaces using COALESCE.
    - Did not use dummy values as the 'OTHER/NONE' rows or unclassified data can give us an indication of how we want to better set up our subscriber information capture using compulsory fields to ensure better data quality and detailed data in the future.
5. **Viewership Table:**
     RecordDate2 column
      - a. CASE Statement for timebands.
      - b. Min/Max Statements to check data period range.
      - c. CASE Statement for splitting weekend and weekday viewing.
      - d. Date Functions to derive month name, day name.
    
      Duration column
      - Important to track most watched channels and
      - Combine to also see average watch time of viewers tracking which gender, age group
      -  Tracking their watching trends to better plan content rights we need as well as content not in demand.

    **User profile Table:** 
     Gender column
       - Group viewing per gender and checking viewing numbers based on gender to plan viewing options for the future.
     Age Column
       - CASE Statement different age groups of viewers.
     Race column 
       - Check racial mix of viewers.
     Province column
       - Geographical profiling and classification in terms of provinces with more potential or lacking viewership numbers and subscribers.
6. Extract final data query into csv file.
     - Checked if extraction was successful
     - Created table
     - Created various pivot tables in new sheet.
     - Created various charts fromt the pivot tables
     - Used Claude/Lovable to get preliminary data insights and Slide Deck creation from the created charts created.
7. Key Insights
     -  Total Sessions 9,995 over Three(3) full months Jan - Mar 2016 (Apr 1st because of UTC to SAST Conversion)
     -  1.522/3 depending on rounding total watch hours > over 63 full days over viewing
     -  21 channel offering with Average watch time of 9.1 minutes
     -  88% of audience is male and 36% of viewing is located in Gauteng Province.
     -  Majority of viewing is from Young Adult group which is 20-35 age group, and 69% watch time is skimming through channels which is less than 5 minutes of watch time.
     -  Sporting viewing dominated by male viewership delivers majority of viewing time.
  
   Recommendations
     - Increase Female audience viewership by improving content targeting lifestyle and reality TV
     - Target after school youth viewing programming
     - For senior viewers improve User Interface for ease of use 
     - Continue acquisition of live sporting events
     - Geographic expansion in NC/FS can partner with Internet Service Providers to provide affordable viewing and internet package to allow device viewing and online viewing
