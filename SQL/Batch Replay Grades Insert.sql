USE [AssignRef]
GO
/****** Object:  StoredProcedure [dbo].[ReplayEntryGrades_BatchInsert]    Script Date: 6/11/2023 1:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author: Javier Barillas
-- Create date: 06/01/2023
-- Description:BatchInsert into dbo.ReplayEntryGrades	 
-- Code Reviewer: Avery Enriquez

-- MODIFIED BY: 
-- MODIFIED DATE:
-- Code Reviewer:
-- Note:
--
-- =============================================

ALTER proc [dbo].[ReplayEntryGrades_BatchInsert]
					@BatchReplayEntryGrades dbo.BatchInsertReplayEntryGrades READONLY,
					@CreatedBy int

as

/*------------------- Test Code ---------------------------

Declare @BatchReplayEntryGrades dbo.BatchInsertReplayEntryGrades,
		@CreatedBy int = 45

Insert Into @BatchReplayEntryGrades (ReplayEntryId, GradeTypeId, Comment)
values (37,2,'Testing Batch Insert')
		  
Execute [dbo].[ReplayEntryGrades_BatchInsert] 

			@BatchReplayEntryGrades,
			@CreatedBy

*/-----------------------------------------------------------

BEGIN

	DECLARE @newIds TABLE ( [Id] int )

	INSERT INTO [dbo].[ReplayEntryGrades]
           ([ReplayEntryId]
           ,[GradeTypeId]
           ,[Comment]
           ,[CreatedBy]
           ,[ModifiedBy])
	
	OUTPUT inserted.[Id] 
	INTO @newIds

	SELECT   b.[ReplayEntryId],
			 b.[GradeTypeId],
			 b.[Comment],
			 @CreatedBy,
			 @CreatedBy
	FROM @BatchReplayEntryGrades as b

	SELECT n.[Id]
	FROM @newIds as n inner join dbo.ReplayEntryGrades as rg
				on n.[Id] = rg.[Id]
	WHERE n.[Id] = rg.[Id]

END