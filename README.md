<h1> Getting-and-Cleaning-Data-Week4-Project</h1>

##Description

The original data were obtained from the site "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" for the Human Activity Recognition Using Smartphones. ( *A full description is available at the site where the data was obtained:*   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones )

Only the dataset files that were used in analysis are described in detail below. The R script included (*run_analysis.R*) assumes that the .zip file has not already been downloaded or extracted. Full descriptions on how data were obtained are available from the .zip file.
<hr>

The files used includes the following (./ indicates the folder containing the datasets):
<ul>

<li>'./features.txt': Contains list of column names for X_train.txt and X_test.txt files</li>

<li>'./activity_labels.txt': Contains deescriptive activity names.</li>

<li>'./train/X_train.txt': Training set.</li>

<li>'./train/y_train.txt': Training activity number labels for each row in X_train.txt.</li>

<li>'./train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. Only 70% of subjects are represented in this file.</li>

<li>'./test/X_test.txt': Test set.</li>

<li>'./test/y_test.txt': Test activity number labels for rows in X_test.txt.</li>

<li>'./test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. Only 30% of subjects are represented in this file.</li>

</ul>

<hr>

All of the data files listed are imported within the R script, cleaned up, merged, and summarized into the output dataset *AcitivityRecognitionUsingSmartphones.txt*.

#To reproduce the Reults

###Pre-requisite libraries
<ul>
<li>  reshape2</li>
<li>  knitr</li>
<li>  markdown</li>
</ul>
To **reproduce** the results copy the *run_analysis.R* and *codeBook.Rmd*files in your working directory and run the script. Using following code.

<pre class="r"><code class="r"><span class="identifier"><span class="identifier">source</span></span><span class="paren"><span class="paren">(</span></span><span class="identifier"><span class="identifier">"run_analysis.R"</span></span><span class="paren"><span class="paren"></span></span><span class="paren"><span class="paren">)</span></span></code></pre>

A codebook is provided to deliver information about the transformations used to clean the data. Variable descriptions are the same as provided in the original dataset.Any change in the variable names is mentioned in the codeBook.md file. Also, how the *run_analysis.R* is working is explained there. Open the following file to view the codebook.

<pre>codeBook.md</pre>

Result will be a tidy data set named *AcitivityRecognitionUsingSmartphones.txt* which will be in working directory. Use the following code to read the Tidy data created.

<pre class="r"><code class="r"><span class="identifier">TidyD</span><span class="operator">&lt;-</span><span class="identifier">read.table</span><span class="paren">(</span><span class="string">"ActivityRecognitionUsingSmartphones.txt"</span>,<span class="identifier">header</span> <span class="operator">=</span> <span class="literal">TRUE</span><span class="paren">)</span>
<span class="identifier">head</span><span class="paren">(</span><span class="identifier">TidyD</span><span class="paren">)</span></code></pre>

CodeBook will also be generated in the working directory as *codeBook.md*. One can open **codeBook.html** file to view the codebook for the tidy dataset.
