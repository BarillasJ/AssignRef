USE [AssignRef]
GO
/****** Object:  StoredProcedure [dbo].[ReplayEntries_Update]    Script Date: 6/11/2023 1:12:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
	-- Author: Javier Barillas
	-- Create date: 05/04/2023
	-- Description: Update Proc For ReplayEntries Table
	-- Code Reviewer: Shannon Rising

	-- MODIFIED BY: 
	-- MODIFIED DATE:
	-- Code Reviewer:
	-- Note: 
	-- =============================================

ALTER Proc [dbo].[ReplayEntries_Update]
			@GameReportId int,
			@EntryTypeId int,
			@PeriodId int,
			@Time time(7)= NULL,
			@ReviewTime time(7) = NULL,
			@TotalTime time(7) = NULL,
			@PossessionTeamId int,
			@PlayTypeId int,
			@Down int = NULL,
			@Distance int = NULL,
			@YTG int = NULL,
			@VideoPlayNumber int = NULL,
			@ROF nvarchar(200),
			@Comment nvarchar(1000) = NULL,
			@ReplayReasonId int,
			@IsChallenge bit,
			@ChallengeTeamId int = NULL,
			@ReplayResultId int,
			@TVTO bit,
			@ModifiedBy int,
			@RulingOfficialsIds dbo.BatchIds READONLY,
			@Id int

 /* ------- Test Code -------

	Declare @Id int = 29,
			@GameReportId int = 6,
			@EntryTypeId int = 1,
			@PeriodId int = 4,
			@Time time(7) = '15:34:07',
			@ReviewTime time(7) = '03:30',
			@TotalTime time(7) = '05:25',
			@PossessionTeamId int = 5,
			@PlayTypeId int = 4,
			@Down int = 4,
			@Distance int = 10,
			@YTG int = 20,
			@VideoPlayNumber int = 2,
			@ROF nvarchar(200) = 'Pass Complete',
			@Comment nvarchar(1000) = 'Camera 10 shows both feet inbounds with control of ball.',
			@ReplayReasonId int = 14,
			@IsChallenge bit = 1,
			@ChallengeTeamId int = null,
			@ReplayResultId int = 3,
			@TVTO bit = 1,
			@ModifiedBy int = 46

	DECLARE @RulingOfficialsIds dbo.BatchIds
		INSERT INTO @RulingOfficialsIds(Id)
		VALUES(3),(5)

	Execute dbo.ReplayEntries_Update
			@GameReportId,
			@EntryTypeId,
			@PeriodId,
			@Time,
			@ReviewTime,
			@TotalTime,
			@PossessionTeamId,
			@PlayTypeId,
			@Down,
			@Distance,
			@YTG,
			@VideoPlayNumber,
			@ROF,
			@Comment,
			@ReplayReasonId,
			@IsChallenge,
			@ChallengeTeamId,
			@ReplayResultId,
			@TVTO,			
			@ModifiedBy,
			@RulingOfficialsIds,
			@Id

 */ --------------------------

  as

 BEGIN

 DECLARE @DateModified datetime2(7) = GETUTCDATE()

 SET IDENTITY_INSERT dbo.FieldPositions on

 DELETE dbo.RulingOfficials
 WHERE ReplayEntryId = @Id

	INSERT INTO [Dbo].[RulingOfficials](ReplayEntryId,PositionId)

		Select @Id,
		fp.Id

		From [dbo].[FieldPositions] as fp
		Where Exists (Select 1
			  From @RulingOfficialsIds as ro
			  Where ro.Id = fp.Id)

	UPDATE [dbo].[ReplayEntries]
		 SET [GameReportId] = @GameReportId,
			 [EntryTypeId] = @EntryTypeId,
			 [PeriodId] = @PeriodId,
			 [Time] = @Time,
			 [ReviewTime] = @ReviewTime,
			 [TotalTime] = @TotalTime,
			 [PossessionTeamId] = @PossessionTeamId,
			 [PlayTypeId] = @PlayTypeId,
			 [Down] = @Down,
			 [Distance] = @Distance,
			 [YTG] = @YTG,
			 [VideoPlayNumber] = @VideoPlayNumber,
			 [ROF] = @ROF,
			 [Comment] = @Comment,
			 [ReplayReasonId] = @ReplayReasonId,
			 [IsChallenge] = @IsChallenge,
			 [ChallengeTeamId] = @ChallengeTeamId,
			 [ReplayResultId] = @ReplayResultId,
			 [TVTO] = @TVTO,
			 [DateModified] = @DateModified,
			 [ModifiedBy] = @ModifiedBy
		Where Id = @Id

 END