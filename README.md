# Data Science Specialization Course Projects

Yangang Chen

Here are my submissions for the course projects for Data Science Specialization. To learn more about Data Science Specialization, please visit https://www.coursera.org/specializations/jhu-data-science

To commit files to GitHub:
* On GitHub website, create a new repo called "Data_Science_Specialization_Projects"
* Create a file "gitupload.sh" in my local directory
* gitupload.sh contains the following bash script
```
#!/bin/bash

git init
git remote add origin https://github.com/yangangchen/Data_Science_Specialization_Projects.git
git branch gh-pages
git remote show origin
git add .
git commit -m 'Final version!'
git push -u origin master
git push -u origin gh-pages
```
If this is not the initial commit, comment the first three lines.
* In the terminal, run
```
sh gitupload.sh
```

