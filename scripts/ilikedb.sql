create database ilikedb;

use ilikedb;

create table UserStatus(
	value varchar(20) primary key not null
)
go

insert into UserStatus (value)
values ('connected'), ('disconnected'), ('do_not_disturb')
go

create table AccountStatus(
	value varchar(10) primary key not null
)
go

insert into AccountStatus (value)
values ('good'), ('muted'), ('banned')
go

create table [User](
	userId uniqueidentifier primary key default newid(),
	username varchar(28) unique not null,
	displayname varchar(56) not null,
	email varchar(255) not null,
	password varchar(255) not null,
	passwordHint varchar(255) not null,
	status varchar(20) references UserStatus(value) default 'disconnected',
	accountStatus varchar(10) references AccountStatus(value) default 'good',
	createdAt datetime default getdate(),
	updatedAt datetime default getdate()
)
go

create table UserProfile(
	userId uniqueidentifier primary key references [User](userId) not null,
	avatarUrl varchar(255),
	bannerUrl varchar(255),
	aboutMe varchar(255),
	color varchar(50),
	updatedAt datetime default getdate()
)
go

create table UserPrivacy(
	userId uniqueidentifier primary key references [User](userId) not null,
	hiddenPostsLikes bit default 1,
	hiddenFavorites bit default 1,
	hiddenBadges bit default 0,
	hiddenFollowers bit default 0,
	hiddenFollowing bit default 0,
	updatedAt datetime default getdate()
)
go

create table SocialLink(
	socialLinkId int primary key identity(1, 1),
	name varchar(50) not null unique,
	url varchar(255) not null unique
)
go

create table UserSocialLinks(
	socialLinkId int references SocialLink(socialLinkId) not null
)
go

create table [Role](
	roleId int primary key identity(1, 1),
	name varchar(10) not null
)
go

create table UserRoles(
	userId uniqueidentifier default newid(),
	roleId int references [Role](roleId) not null
)
go

create table Follow(
	userFollowerId uniqueidentifier references [User](userId),
	userFollowedId uniqueidentifier references [User](userId),
	followedAt datetime default getdate()
)
go

create table Topic(
	topicId uniqueidentifier primary key default newid(),
	name varchar(50) not null,
	description varchar(100),
	bannerUrl varchar(255) not null,
	createdAt datetime default getdate(),
	updatedAt datetime default getdate()
)
go

create table TopicLikes(
	topicId uniqueidentifier references Topic(topicId) not null,
	userId uniqueidentifier references [User](userId) not null
)
go

create table [Space](
	spaceId uniqueidentifier primary key default newid(),
	name varchar(50) not null,
	description varchar(100),
	bannerURL varchar(255) not null,
	managerId uniqueidentifier references [User](userId) not null,
	topicId uniqueidentifier references Topic(topicId) not null,
	createdAt datetime default getdate(),
	updatedAt datetime default getdate()
)
go

create table SpaceLikes(
	spaceId uniqueidentifier references [Space](spaceId),
	userId uniqueidentifier references [User](userId)
)
go

create table Post(
	postId uniqueidentifier primary key default newid(),
	author uniqueidentifier references [User](userId) not null,
	title varchar(50) not null,
	content varchar(4000) not null,
	bannerUrl varchar(255) not null,
	spaceId uniqueidentifier references [Space](spaceId) not null,
	createdAt datetime default getdate(),
	updatedAt datetime default getdate()
)
go

create table PostTags(
	postId uniqueidentifier references Post(postId) not null,
	value varchar(30) not null
)
go

create table PostLikes(
	postId uniqueidentifier references Post(postId) not null,
	userId uniqueidentifier references [User](userId) not null
)
go

create table PostComments(
	postId uniqueidentifier references Post(postId) not null,
	userId uniqueidentifier references [User](userId) not null,
	value varchar(1000) not null,
	createdAt datetime default getdate(),
	updatedAt datetime default getdate()
)
go

create table PostShared(
	postId uniqueidentifier references Post(postId) not null,
	userId uniqueidentifier references [User](userId) not null
)

create table TopicSpaces(
	topicId uniqueidentifier references Topic(topicId),
	spaceId uniqueidentifier references [Space](spaceId)
)
go

create table SpacePosts(
	spaceId uniqueidentifier references [Space](spaceId),
	postId uniqueidentifier references Post(postId)
)
go

insert into Role (name)
values ('superadmin'), ('admin'), ('mod'), ('support'), ('user')
go
