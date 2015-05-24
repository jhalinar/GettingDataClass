run_analysis<-function() {##start1
##function to make new header names
newhead<-function(Vector,rm,add) 	
	{#start_newhead
	v=gsub(rm,'',Vector,fixed=TRUE)
	v.new=vector()
	for(i in 1:length(v)) 
		{
		word=as.character(v[i])
		first=substr(word,1,1)
		rest=substr(word,2,nchar(word))
		rest=sub('Acc','Accelerometer',rest,fixed=TRUE)
		rest=sub('Gyro','Gyroscope',rest,fixed=TRUE)
		v.new[i]=paste(first,'-',add,rest,sep='')
		}
	return(v.new)
	}#emd_newhead

path='./UCI HAR Dataset/'
path_test='./UCI HAR Dataset/test/'
path_train='./UCI HAR Dataset/train/'
##read header names
HEAD=read.table(paste(path,'/features.txt',sep=''),as.is=TRUE)[,2]
##find index of header names that contain mean() and std()
which.mean=grep('mean()',HEAD,fixed=TRUE)
which.std=grep('std()',HEAD,fixed=TRUE)
##determine which columns to extract for final data frame
columns=append(which.mean,which.std)
##create vector where feature contains mean()
HEAD.mean=HEAD[which.mean]
##call newhead to create new header names
HEAD.mean=newhead(HEAD.mean,'-mean()','Mean')
##create vector where feature contains std()
HEAD.std=HEAD[which.std]
##call newhead to create new header names
HEAD.std=newhead(HEAD.std,'-std()','Std')
##append the two header vectors
NEWHEAD=append(HEAD.mean,HEAD.std)
##correct typo error in dataset
NEWHEAD=sub('BodyBody','Body',NEWHEAD,fixed=TRUE)	
##read subject and activity from train and test datasets and activity lables
train.sub=as.vector(read.table(paste(path_train,'subject_train.txt',sep='')))[,1]
test.sub=as.vector(read.table(paste(path_test,'subject_test.txt',sep='')))[,1]
train.activity=as.vector(read.table(paste(path_train,'y_train.txt',sep='')))[,1]
test.activity=as.vector(read.table(paste(path_test,'y_test.txt',sep='')))[,1]
activity.label=as.vector(read.table(paste(path,'activity_labels.txt',sep='')))[,2]
##read data from train and test datsets, rbind them and set header names
df.train=read.table(paste(path_train,'X_train.txt',sep=''))[,columns]
df.test=read.table(paste(path_test,'X_test.txt',sep=''))[,columns]
df=rbind(df.train,df.test)
names(df)=NEWHEAD
##combine subject and activity vectors from train and test datasets
subject=append(train.sub,test.sub)
activity=append(train.activity,test.activity)
activityByNames=as.character(activity)
##replace activity index with activity name
for(i in 1:6) activityByNames=sub(i,activity.label[i],activityByNames,fixed=TRUE)
activityByNames=tolower(activityByNames)
##create final data frame
df=data.frame(subject=subject,activityID=activity,activityName=activityByNames,df)
##calculate mean valves over subject and activity
result=aggregate(.~subject+activityName,data=df,mean)
return(result)
}##end1


