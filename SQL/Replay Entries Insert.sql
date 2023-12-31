USE [AssignRef]
GO
/****** Object:  StoredProcedure [dbo].[ReplayEntries_Insert]    Script Date: 6/11/2023 1:11:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


	-- =============================================
	-- Author: Javier Barillas
	-- Create date: 05/04/2023
	-- Description: Insert Proc For ReplayEntries Table
	-- Code Reviewer: Shannon Rising

	-- MODIFIED BY: 
	-- MODIFIED DATE:
	-- Code Reviewer:
	-- Note: 
	-- =============================================



ALTER Proc [dbo].[ReplayEntries_Insert]
			@GameReportId int,
			@EntryTypeId int,
			@PeriodId int,
			@Time time(7) = NULL,
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
			@CreatedBy int,
			@RulingOfficialsIds dbo.BatchIds READONLY,
			@Id int Output
 

 as

 /* ------- Test Code -------

	DECLARE @Id int = 0,
			@GameReportId int = 3,
			@EntryTypeId int = 1,
			@PeriodId int = 4,
			@Time time(7) = null,
			@ReviewTime time(7) = null,
			@TotalTime time(7) = null,
			@PossessionTeamId int = 6,
			@PlayTypeId int = 4,
			@Down int = 3,
			@Distance int = 9,
			@YTG int = 21,
			@VideoPlayNumber int = 2,
			@ROF nvarchar(200) = 'Incomplete Pass',
			@Comment nvarchar(1000) = 'testing',
			@ReplayReasonId int = 13,
			@IsChallenge bit = 0,
			@ChallengeTeamId int = 17,
			@ReplayResultId int = 1,
			@TVTO bit = 1,
			@CreatedBy int = 44,
			@RulingOfficialsIds dbo.BatchIds
		
	INSERT INTO @RulingOfficialsIds (Id)
				VALUES (7), (8)


	EXECUTE dbo.ReplayEntries_Insert
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
			@CreatedBy,
			@RulingOfficialsIds,
			@Id Output

 */ --------------------------

 Begin


Insert Into [dbo].[ReplayEntries]
				([GameReportId],
					 [EntryTypeId],
					 [PeriodId],
					 [Time],
					 [ReviewTime],
					 [TotalTime],
					 [PossessionTeamId],
					 [PlayTypeId],
					 [Down],
					 [Distance],
					 [YTG],
					 [VideoPlayNumber],
					 [ROF],
					 [Comment],
					 [ReplayReasonId],
					 [IsChallenge],
					 [ChallengeTeamId],
					 [ReplayResultId],
					 [TVTO],
					 [CreatedBy],
					 [ModifiedBy])

	Values (@GameReportId,
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
			@CreatedBy,
			@CreatedBy)


		Set	@Id = SCOPE_IDENTITY();


	INSERT INTO [dbo].[RulingOfficials] (ReplayEntryId
											,PositionId)

		Select @Id
				,fp.Id

		From [dbo].[FieldPositions] as fp
		Where Exists (Select 1
			  From @RulingOfficialsIds as ro
			  Where ro.Id = fp.Id)
		
 End
