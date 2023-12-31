USE [AssignRef]
GO
/****** Object:  StoredProcedure [dbo].[Games_ReplayReport_ByGameId_Detailed]    Script Date: 6/11/2023 1:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
	-- Author: Javier Barillas
	-- Create date: 05/12/2023
	-- Description: Select Proc for Detailed Game Report With Replay Entries
	--				and Assignments By Game Id V2
	-- Code Reviewer: Alicia St. Denis

	-- MODIFIED BY: 
	-- MODIFIED DATE:
	-- Code Reviewer:
	-- Note: 
	-- =============================================

ALTER PROC [dbo].[Games_ReplayReport_ByGameId_Detailed]
			
			@GameId int
			
/*--------Test Code -------

Declare @GameId int = 40;

Execute [dbo].[Games_ReplayReport_ByGameId_Detailed]
			  @GameId

*/--------------------------

as

BEGIN

	  SELECT gr.[Id]
			,gr.[GameId]
			,s.[Year]
			,g.[Week]
			,c.[Id] as conferenceId
			,c.[Name] as conferenceName		
			,c.[Code] as conferenceCode			
			,c.[Logo] as conferenceLogo				
			,ht.[Id] as homeTeamId
			,ht.[Name] as homeTeamName
			,ht.[Code] as homeTeamCode
			,ht.[Logo] as homeTeamLogo
			,gr.[HomeScore]
			,vt.[Id] as homeTeamId
			,vt.[Name] as visitingTeamName
			,vt.[Code] as visitingTeamCode
			,vt.[Logo] as visitingTeamLogo
			,gr.[VisitingScore]
			,gr.[StartTime]
			,gr.[EndTime]
			,gr.[TotalTime]
			,gr.[Halftime]
			,gr.[IsOvertime]
			,gr.[OvertimePeriods]
			,gr.[IsTV]
			,gs.[Id] as gameStatusId
			,gs.[Name] as gameStatus
			,gr.[DateCreated]
			,gr.[DateModified]
			,createrUser.[Id] as 'CreatorId'
			,createrUser.[FirstName] as 'CreatorFirstName'
			,createrUser.[LastName] as 'CreatorLastName'
			,createrUser.[Mi] as 'CreatorMi'
			,createrUser.[AvatarUrl] as 'CreatorAvatar'
			,ReplayEntries = ( SELECT re.[Id] as Id,
									  g.[Id] as GameId,							
									  gr.[Id] as GameReportId,
									  et.[Id] as 'EntryType.Id',
									  et.[Name] 'EntryType.Name',
									  p.[Id] as 'Period.Id',
									  p.[Name] as 'Period.Name',
									  re.[Time],
									  re.[ReviewTime],
									  re.[TotalTime],
									  posst.[Id] as 'PossessionTeam.Id',
									  posst.[Name] as 'PossessionTeam.Name',
									  posst.[Code] as 'PossessionTeam.Code',
									  posst.[Logo] as 'PossessionTeam.Logo',
									  pt.[Id] as 'PlayType.Id',
									  pt.[Name] as 'PlayType.Name',
									  re.[Down],
									  re.[Distance],
									  re.[YTG],
									  re.[VideoPlayNumber],
									  re.[ROF],
									  re.[Comment] as Comments,
									  rsn.[Id] as 'ReplayReason.Id',
									  rsn.[Name] as 'ReplayReason.Name',
									  re.[IsChallenge],
									  challt.[Id] as 'ChallengeTeam.Id',
									  challt.[Name] as 'ChallengeTeam.Name',
									  challt.[Code] as 'ChallengeTeam.Code',
									  challt.[Logo] as 'ChallengeTeam.Logo',
									  rst.[Id] 'ReplayResult.Id',
									  rst.[Name] 'ReplayResult.Name',
								   	  re.[TVTO],
									  re.[DateCreated],
									  re.[DateModified],
									  re.[CreatedBy],
									  re.[ModifiedBy],																		  
									  RulingOfficials = JSON_QUERY(
											'[' + STUFF(( SELECT ',' + '"' + fp.Code + '"' 
											FROM dbo.FieldPositions as fp
											INNER JOIN [dbo].[RulingOfficials] as ro
											ON ro.PositionId = fp.Id
											WHERE ro.ReplayEntryId = re.Id
											FOR XML PATH('')),1,1,'') + ']' ) 														  	 		
							  FROM [dbo].[ReplayEntries] as re
							  INNER JOIN [dbo].[EntryTypes] as et
							  ON et.Id = re.EntryTypeId
							  INNER JOIN [dbo].[Periods] as p
							  ON p.Id = re.PeriodId
							  INNER JOIN [dbo].[PlayTypes] as pt
							  ON pt.Id = re.PlayTypeId
							  INNER JOIN [dbo].[Teams] as posst
							  ON posst.Id = re.PossessionTeamId
							  FULL OUTER JOIN [dbo].[Teams] as challt
							  ON challt.Id = re.ChallengeTeamId
							  INNER JOIN [dbo].[ReplayReasons] as rsn
							  ON rsn.Id = re.ReplayReasonId
							  INNER JOIN [dbo].[ReplayResults] as rst
							  ON rst.Id = re.ReplayResultId	
							  WHERE re.GameReportId = gr.Id
							  ORDER BY re.Id DESC
							  FOR JSON Path
								    )
			 ,Assignments = ( SELECT a.[Id]								
			                        ,ast.[Id] as 'AssignmentType.id'
									,ast.[Name] as 'AssignmentType.Name'
									,fp.[Id] as 'Position.Id'
									,fp.[Name] as 'Position.Name'
									,fp.[Code] as 'Position.Code'
									,usr.[Id] as 'User.Id'									
									,usr.[FirstName] as 'User.FirstName'
									,usr.[LastName] as 'User.LastName'
									,usr.[Mi] as 'User.MI'
									,usr.[AvatarUrl] as 'User.AvatarUrl'
									,usr.[Email] as 'User.Email'									
									,gt.[Id]  as 'User.Gender.Id'
									,gt.[Name] as 'User.Gender.Name'
									,usr.[Phone] as 'User.Phone'
									,usr.[isConfirmed] as 'User.IsConfirmed'
									,usr.[StatusId] as 'User.Status'
									,a.[Fee] 
									,asi.[Id] as 'AssignmentStatus.Id'
									,asi.[Name] as 'AssignmentStatus.Name'
									,a.[DateCreated]
									,a.[DateModified]
									,a.[CreatedBy]
									,a.[ModifiedBy]									
							  FROM [dbo].[Assignments] as a	
						  	  INNER JOIN [dbo].[AssignmentTypes] as ast
							  ON a.AssignmentTypeId = ast.Id
							  INNER JOIN [dbo].[FieldPositions] as fp
							  On a.PositionId = fp.Id
							  INNER JOIN [dbo].[Users] as usr 
							  ON a.UserId = usr.Id
							  INNER JOIN [dbo].[AssignmentStatus] as asi
							  ON a.AssignmentStatusId = asi.Id
							  INNER JOIN [dbo].[GenderTypes] as gt
							  ON usr.GenderId = gt.Id
							  WHERE a.GameId = @GameId							  
							  FOR JSON PATH
									)							
		FROM [dbo].[GameReports] as gr
		INNER JOIN [dbo].[Games] as g
		ON gr.GameId = g.Id
		INNER JOIN [dbo].[Seasons] as s
		ON g.SeasonId = s.Id
		INNER JOIN [dbo].[Conferences] as c
		ON c.Id = g.ConferenceId
		INNER JOIN [dbo].[Teams] as ht
		ON ht.Id = g.HomeTeamId
		INNER JOIN [dbo].[Teams] as vt
		ON vt.Id = g.VisitingTeamId
		INNER JOIN [dbo].[GameStatus] as gs
		ON gs.Id = g.GameStatusId
		INNER JOIN [dbo].[Users] as createrUser
		ON createrUser.Id = gr.CreatedBy																
		WHERE @GameId = gr.GameId 

END