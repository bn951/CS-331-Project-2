-- =============================================
-- Author:		Kate Padua
-- Create date: April 14, 2019
-- Description:	This will show the Work flow each member  made throughout the project
-- =============================================


CREATE PROCEDURE Process.usp_ShowWorkflowSteps 

	@StartTime DATETIME2,
	@EndTime DATETIME2,
	@WorkFlowDesc NVARCHAR(100),
	@UserAuthorization INT,
	@TableRowCount INT

AS
BEGIN
	SELECT D.UserAuthorizationKey, D.GroupMemberFirstName, D.GroupMemberLastName,
			P.StartingDateTime, P.EndingDateTime, P.WorkFlowStepDescription, P.WorkFlowStepTableRowCount
	FROM Process.WorkflowSteps as P
	INNER JOIN DbSecurity.UserAuthorization as D
		ON D.UserAuthorizationKey = P.UserAuthorizationKey
	WHERE
	@StartTime = StartingDateTime AND
	@EndTime = EndingDateTime AND
	@WorkFlowDesc = WorkFlowStepDescription AND
	@TableRowCount = WorkFlowStepTableRowCount
		 


END
GO
