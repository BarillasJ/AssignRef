USE [AssignRef]
GO
/****** Object:  StoredProcedure [dbo].[Games_SelectBySeasonId_ConferenceIdV2]    Script Date: 6/11/2023 1:16:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================
-- Author: Javier Barillas
-- Create date: 06/01/2023
-- Description:	select all games according to seasonId and conferenceId V2
-- Code Reviewer: Avery Enriquez

-- MODIFIED BY: 
-- MODIFIED DATE:
-- Code Reviewer:
-- Note:
-- =============================================


ALTER proc [dbo].[Games_SelectBySeasonId_ConferenceIdV2]
							@SeasonId int
						   ,@ConferenceId int

as

/* ---------------- Test Code --------------

	DECLARE @SeasonId int = 6,
			@ConferenceId int = 1

	EXECUTE dbo.Games_SelectBySeasonId_ConferenceIdV2

			@SeasonId,
			@ConferenceId

*/ -------------------------------------------

BEGIN

	SELECT g.[Id] as GameId,
		   gs.[Id] as GameStatusId,
		   gs.[Name],
		   season.[Id] as SeasonId,
		   season.[Name],
		   season.[Year],
		   g.[Week],
		   c.[Id] as ConferenceId,
		   c.[Name],
		   c.[Code],
		   c.[Logo],		
		   ht.[Id] as HomeTeamId,
		   ht.[Name],
		   ht.[Code],
		   ht.[Logo],
		   cht.[Id] as HomeTeamConferenceId,
		   cht.[Name],
		   cht.[Code],
		   cht.[Logo],
		   lht.[Id] as HomeLocationId,
		   lht.[LineOne],
		   lht.[LineTwo],
		   lht.[City],
		   sht.[Id] as StateId,
		   sht.[Name],
		   sht.[Code],
		   lht.[Zip],
		   lht.[Latitude],
		   lht.[Longitude],
		   hlt.[Id] as HomeLocationTypeId,
		   hlt.[Name],
		   vht.[Id] as HomeVenueId,
		   vht.[Name],
		   hvl.[Id] as HomeVenueLocationId,
		   hvl.[LineOne],
		   hvl.[LineTwo],
		   hvl.[City],
		   hvs.[Id] as HomeVenueStateId,
		   hvs.[Code],
		   hvs.[Name],
		   hvl.[Zip],
		   hvl.[Latitude],
		   hvl.[Longitude],
		   hvlt.[Id] as HomeVenueLocationTypeId,
		   hvlt.[Name],
		   vht.[PrimaryImageUrl],
		   ht.[PrimaryColor],
		   ht.[SecondaryColor],
		   ht.[Phone],
		   ht.[SiteUrl],
		   hst.[Id] as HomeStatusTypeId,
		   hst.[Name],
		   HomeTeamMembers = (SELECT tm.[Id], 
									 u.[FirstName], 
									 u.[LastName], 
									 u.[Mi], 
									 u.[AvatarUrl], 
									 u.[Email], 
									 u.[Phone], 
									 tm.[IsPrimaryContact], 
									 tm.[Position] 
									 FROM [dbo].[Users] as u INNER JOIN [dbo].[TeamMembers] as tm
									 ON tm.[UserId] = u.[Id]
									 WHERE tm.[TeamId] = ht.[Id]
									 FOR JSON PATH),
		   ht.[DateCreated],
		   ht.[DateModified],
		   vt.[Id] as VistingTeamId,
		   vt.[Name],
		   vt.[Code],
		   vt.[Logo],
		   cvt.[Id] as VisitingTeamConferenceId,
		   cvt.[Name],
		   cvt.[Code],
		   cvt.[Logo],
		   lvt.[Id] as VisitingLocationId,
		   lvt.[LineOne],
		   lvt.[LineTwo],		   
		   lvt.[City],
		   svt.[Id] as VisitingStateId,
		   svt.[Name],
		   svt.[Code],
		   lvt.[Zip],
		   lvt.[Latitude],
		   lvt.[Longitude],
		   vlt.[Id] as VisitingLocationTypeId,
		   vlt.[Name],
		   vvt.[Id] as VisitingVenueId,
		   vvt.[Name],
		   vvl.[Id] as VisitingVenueLocationId,
		   vvl.[LineOne],
		   vvl.[LineTwo],
		   vvl.[City],
		   vvs.[Id] as VisitingVenueStateId,
		   vvs.[Code],
		   vvs.[Name],
		   vvl.[Zip],
		   vvl.[Latitude],
		   vvl.[Longitude],
		   vvlt.[Id] VisitingVenueLocationTypeId,
		   vvlt.[Name],
		   vvt.[PrimaryImageUrl],
		   vt.[PrimaryColor],
		   vt.[SecondaryColor],
		   vt.[Phone],
		   vt.[SiteUrl],
		   vst.[Id] as VisitingStatusId,
		   vst.[Name],
		   VisitingTeamMembers = (SELECT tm.[Id], 
										 u.[FirstName], 
										 u.[LastName], 
										 u.[Mi], 
										 u.[AvatarUrl], 
										 u.[Email], 
										 u.[Phone], 
										 tm.[IsPrimaryContact], 
										 tm.[Position] 
										 FROM [dbo].[Users] as u INNER JOIN [dbo].[TeamMembers] as tm
										 ON tm.[UserId] = u.[Id]
										 WHERE tm.[TeamId] = vt.[Id]
										 FOR JSON PATH),
		   vt.[DateCreated],
		   vt.[DateModified],
		   g.[StartTime],
		   g.[IsNonConference],
		   v.[Id] as VenueId,
		   v.[Name] as VenueName,
		   l.[Id] as GameLocationId,		 
		   l.[LineOne],
		   l.[LineTwo],
		   l.[City],
		   s.[Id] as GameLocationStateId,
		   s.[Code],
		   s.[Name],
		   l.[Zip],
		   l.[Latitude],
		   l.[Longitude],
		   lt.[Id] as GameLocationTypeId,
		   lt.[Name],
		   v.[PrimaryImageUrl],
		   g.[DateCreated],
		   g.[DateModified],
		   g.[IsDeleted],
		   createUser.[Id] as CreateUserId,
		   modifiedUser.[Id] as ModifiedUserId,
		   Officials = (  SELECT ofi.Id as 'Id',
									us.Id as 'User.Id',
									us.[FirstName] as 'User.FirstName', 
									us.[LastName]  as 'User.LastName', 
									us.[Mi]  as 'User.MiddleName', 
									us.[AvatarUrl]  as 'User.AvatarUrl',
									gen.[Name] as 'Gender',
									fp.Id as 'Position.Id' ,
									fp.[Name]  as 'Position.Name',
									fp.Code  as 'Position.Code'
						FROM dbo.Assignments as ass 
						JOIN dbo.Games as gm ON ass.GameId = gm.Id
						JOIN dbo.Officials as ofi ON ass.UserId = ofi.UserId
						JOIN dbo.Users as us ON US.Id = Ofi.UserId
						JOIN dbo.GenderTypes as gen ON gen.Id = us.GenderId
						JOIN dbo.FieldPositions as fp ON fp.Id  = ass.PositionId AND ass.AssignmentTypeId = 1
						WHERE ass.GameId = g.Id
						FOR JSON PATH
						)
   FROM [dbo].[Games] g
		INNER JOIN [dbo].[GameStatus] as gs
		ON g.GameStatusId = gs.Id
		INNER JOIN [dbo].[Seasons] as season
		ON g.SeasonId = season.Id
		INNER JOIN [dbo].[Conferences] as c
		ON g.ConferenceId = c.Id
		INNER JOIN [dbo].[Venues] as v
		ON g.VenueId = v.Id
		INNER JOIN [dbo].[Locations] as l
		ON v.LocationId = l.Id
		INNER JOIN [dbo].[LocationTypes] as lt
		ON l.LocationTypeId = lt.Id
		INNER JOIN [dbo].[States] as s
		ON l.StateId= s.Id
		INNER JOIN [dbo].[Users] as createUser
		ON g.CreatedBy = createUser.Id
		INNER JOIN [dbo].[Users] as modifiedUser
		ON g.ModifiedBy = modifiedUser.Id
		 -------Home Team-----------
		INNER JOIN [dbo].[Teams] as ht
		ON g.HomeTeamId= ht.Id
		INNER JOIN [dbo].[StatusTypes] as hst
		ON hst.Id = ht.StatusTypeId
		INNER JOIN [dbo].[Locations] as lht
		ON ht.LocationId = lht.Id
		INNER JOIN [dbo].[LocationTypes] as hlt
		ON lht.LocationTypeId = hlt.Id	
		INNER JOIN [dbo].[States] as sht
		ON lht.StateId = sht.Id
		INNER JOIN [dbo].[Conferences] as cht
		ON ht.ConferenceId = cht.Id
		 ------Home Team Venue-------
		INNER JOIN [dbo].[Venues] as vht
		ON ht.MainVenueId = vht.Id
		INNER JOIN [dbo].[Locations] as hvl
		ON vht.LocationId = hvl.Id
		INNER JOIN [dbo].[States] as hvs
		ON hvs.Id = hvl.StateId
		INNER JOIN [dbo].[LocationTypes] as hvlt
		ON hvlt.Id = hvl.LocationTypeId
		 -----Visiting Team----------
		INNER JOIN [dbo].[Teams] as vt
		ON g.VisitingTeamId = vt.Id
		INNER JOIN [dbo].[StatusTypes] as vst
		ON vst.Id = vt.StatusTypeId
		INNER JOIN [dbo].[Locations] as lvt
		ON vt.LocationId = lvt.Id
		INNER JOIN [dbo].[LocationTypes] as vlt
		ON lvt.LocationTypeId = vlt.Id		
		INNER JOIN [dbo].[States] as svt
		ON lvt.StateId = svt.Id
		INNER JOIN [dbo].[Conferences] as cvt
		ON vt.ConferenceId = cvt.Id
		 -----Visiting Team Venue-------
		INNER JOIN [dbo].[Venues] as vvt
		ON vt.MainVenueId = vvt.Id
		INNER JOIN [dbo].[Locations] as vvl
		ON vvt.LocationId = vvl.Id
		INNER JOIN [dbo].[States] as vvs
		ON vvs.Id = vvl.StateId
		INNER JOIN [dbo].[LocationTypes] as vvlt
		ON vvlt.Id = vvl.LocationTypeId

	WHERE g.SeasonId = @SeasonId AND
		  g.ConferenceId = @ConferenceId AND
		  NOT EXISTS (SELECT 1
					 FROM dbo.GameReports
					 WHERE dbo.GameReports.gameId = g.Id
					 );

End