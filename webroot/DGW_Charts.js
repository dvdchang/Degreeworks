/*
 * Copyright 1995-2012 Ellucian Company L.P. and its affiliates. 
 */
// $Id: //Tuxedo/RELEASE/Product/webroot/DGW_Charts.js#8 $
//////////////////////////////////////////////////////////////////
// DGW_Charts.js
// Before making any changes to the standard SunGard Bi-Tech .js file
// be sure to save it to DGW_Charts.js.sbi so that you have a working
// copy in case you need to undo your changes.
// When changes are made be sure to log them here at the top so that
// SBI and you can track your changes.
//////////////////////////////////////////////////////////////////
// Global Variables
iCredMax = 150;  // The Maximum number of credits that will be shown in the Advice Calculator results
IndividualClassCreditMax = 8; // The maximum number of credits an individual class can be worth.  Used in the Term Calculator.
IndividualClassGradeMax  = 5; // The maximum grade a student can earn.  This used to be hardcoded as 4, but grades may be slightly higher than 4.  Used in the Term Calculator.
// Error Messages
Err1 =  "Please use only numeric values.";
Err2 =  "";
//Err3 =  sCreditsLit + " Remaining cannot be greater than " + sCreditsLit + " Required."; 
//Err4 =  sCreditsLit + " Remaining should not equal " + sCreditsLit + " Required.  Your GPA would be 0.";
Err5 =  "To achieve your desired GPA, you would need to average higher than a 4.0.  You would need to average a ";
Err6 =  "Your GPA cannot get that low.";
Err7 =  "No grades have been entered.  To calculate your term GPA, you must provide some class information.";
Err8 =  "Current GPA is invalid.  Please enter a valid GPA.";
//Err9 =  sCreditsLit + " Earned is invalid.  Please enter valid " + sCreditsLit + " Earned.";
//Err10 = "Achieving your desired GPA is not possible or not realistic.  It would require too many " + sCreditsLit;
Err11 = "Desired GPA is invalid.  Please enter a valid GPA.";
//Err12 = sCreditsLit + " Remaining is invalid.  Please enter valid " + sCreditsLit + " Remaining.";
//Err13 = sCreditsLit + " Required is invalid.  Please enter valid " + sCreditsLit + " Required.";
Err14 = "An invalid Grade was found.  Please enter valid Grades.";
//Err15 = "An invalid " + sCreditsLit + " was found.  Please enter a valid " + sCreditsLit + ".";

var iParentHistoryLength = 0;
////////////////////////////////////////////////////////
function rite(sValue)
{
	document.writeln(sValue);
}
////////////////////////////////////////////////////////////////////////////
// DRAWPROGRESSBAR
// Draw the Progress Bar 
// Special Notes:
// If progress < 100 (most cases), the auditor will return the value as "XX%".
// If progress = 100%, the auditor will return the value as "100".  This is
// a special case.
// If the progress is "0%", this is a special case.  The number displayed must
// be displayed in a darker color, as white on the brown background does not
// display well.
////////////////////////////////////////////////////////////////////////////
function DrawProgressBar(sProgress, sTitle)
{
	rite('<!-- ========================= PROGRESS BAR =========================== -->');
    rite('<center>');
    rite('<span class="ProgressTitle"> ' + sTitle + ' </span>');
    rite('<table cellpadding=0 cellspacing=0 class="ProgressTable">');
    rite('<tr>');
	
	if (sProgress == "0% ")
		{rite('  <td width="5%">');}
	else if (sProgress == "100")
		{rite('  <td width="100%">');}
	else // (sProgress between 0% and 100%)
		{rite('  <td width="' + sProgress + '">');}
    
    rite('   <table cellpadding=0 cellspacing=0  border=0 width="100%">');
    rite('     <tr>');
	
	if (sProgress == "0% ")
		{rite('     <td class="ProgressBarZero"><center> 0% ');}
	else if (sProgress == "100")
		{rite('     <td class="ProgressBar"><center> 100% ');}
	else // (sProgress between 0% and 100%)
		{rite('     <td class="ProgressBar"><center>' + sProgress);}
    
    rite('     </center></td>');
    rite('     </tr>');
    rite('   </table>');
    rite('   </td>');
    if (sProgress=="100")
		rite('   <td>');
	else
		rite('   <td>     &nbsp; ');
    rite('   </td>');
    rite('</tr>');
    rite('</table>');
    rite('</center>');
    rite('<br>');
} // drawprogressbar
////////////////////////////////////////////////////////////////////////////
// ERRORITEM
// Error Array structure.
////////////////////////////////////////////////////////////////////////////
function ErrorItem(sErrorNum, sErrorOther)
{
	this.ErrorNum   = sErrorNum;
	this.ErrorOther = sErrorOther;
}
////////////////////////////////////////////////////////////////////////////
// COURSEITEM
// Course Array Structure.  For the Term Calculator function CalculateTermGPA()
////////////////////////////////////////////////////////////////////////////
function CourseItem(sCredits, sGrade, sLetterGrade, sNumericGrade, sCourseKey) 
{
    this.credits = sCredits;
    this.grade = sGrade;
		this.gradeLetter = sLetterGrade;
    this.gradeNumber = sNumericGrade;
		this.courseKey = sCourseKey;
}
////////////////////////////////////////////////////////////////////////////
// DISPLAYCOURSEITEM
// Display Course Array Structure.  For the function DrawList() for "TERM" calculator
////////////////////////////////////////////////////////////////////////////
function DisplayCourseItem(sCredits, sGradeNumber, sGradeLetter, sCourseKey) 
{
        this.credits = sCredits;
        this.gradeNumber = sGradeNumber;
        this.gradeLetter = sGradeLetter;
        this.courseKey = sCourseKey;
}
////////////////////////////////////////////////////////////////////////////
// RESULTITEM
// Result Array Structure.  For the Advice Calculator function CalculateAdviceGPA()
////////////////////////////////////////////////////////////////////////////
function ResultItem(sCredits, sAverage, sGrade, sCreditsLit)
{
	this.credits = sCredits;
	this.average = sAverage;
	this.grade = sGrade;
	this.lit = sCreditsLit;
}
////////////////////////////////////////////////////////////////////////////
// CALCULATEGPA
// Perform the functions of the Graduation GPA Calculator 
// Calculate the GPA the user needs to average over their final X credits to achieve
// the desired GPA.
// Inputs:  Form Data from SD2GPTRM (including CurrentGPA, Credits Remaining, Credits Required, Desired GPA),
//          CREDITS literal (for display purposes),
//          Number of decimals to round to (CFG020 WEB setting)

// Output:  If there are input errors: Error array
//          If there are no errors:    GPA needed to achieve desired GPA, sForm (to display what the user input)
////////////////////////////////////////////////////////////////////////////
function CalculateGPA(sForm, sCreditsLit, iRounding, iRoundOrTruncate)
{
	// GradeData is an array that will be loaded with all the grade information.
	// This way, all we need to pass to the DrawList function will be the array.
	var GradeData = new Array();	
	// GradeData Structure:
	// sCreditsLit			(Credits Literal; UCXSCR001 key=CREDITS, bytes 1:30)

	// sCurrentGPA			(Current GPA; entered by user)
	// sCredRemain			(Current Credits remaining; entered by user)
	// sCredReq				(Credits Required; entered by user)
	// sDesiredGPA			(Desired GPA; entered by user)
	// sCredEarned			(Credits Earned So Far; calculated)
	//							[Credits Required - Credits Remaining]
	// sGradePointBalance	(Grade Points Earned So Far; calculated)
	//							[Current GPA * Credits Earned So Far]
	// sGradePointNeeded	(Grade Points that need to be earned to achieve desired GPA; calculated)
	//							[DesiredGPA * Credits Required - Grade Points Earned So Far]
	// sTotalGradePoints	(Total Grade Points that need to be earned to achieve desired GPA; calculated)
	//							[Grade Points Needed + Grade Point Balance]
	// sGPANeeded			(GPA needed until graduation to achieve desired GPA; calculated)
	//							[Grade Points Needed / Credits Remaining]
	GradeData.length = 0;
	var ErrorList = new Array();
	ErrorList.length = 0;
	ErrorList.ErrOther = "";
	ErrorListCtr = 0;
	var HoldNum;
	GradeData.sCreditsLit = sCreditsLit;
	//GradeData.sCurrentGPA = sForm.CURRENTGPAFULL.value;
	GradeData.sCurrentGPA = sForm.CURRENTGPA.value;
	GradeData.sCredRemain = sForm.CREDREMAIN.value;
	GradeData.sCredReq    = sForm.CREDREQ.value;
	GradeData.sDesiredGPA = sForm.DESIREDGPA.value;
	// Make sure the data the user has inputted is numeric (VALIDATION)
	if (!IsNumeric(GradeData.sCurrentGPA)){
		ErrorList[ErrorListCtr] = new ErrorItem(Err8, "");
		ErrorListCtr++;}
	if (!IsNumeric(GradeData.sCredRemain)){
		ErrorList[ErrorListCtr] = new ErrorItem(sCreditsLit + " Remaining is invalid.  Please enter valid " + sCreditsLit + " Remaining.", "");
		ErrorListCtr++;}
	if (!IsNumeric(GradeData.sCredReq)){
		ErrorList[ErrorListCtr] = new ErrorItem(sCreditsLit + " Required is invalid.  Please enter valid " + sCreditsLit + " Required.", "");
		ErrorListCtr++;}
	if (!IsNumeric(GradeData.sDesiredGPA)){
		ErrorList[ErrorListCtr] = new ErrorItem(Err11, "");
		ErrorListCtr++;}
	GradeData.sCredEarned  = GradeData.sCredReq - GradeData.sCredRemain;
	GradeData.sGradePointBalance = GradeData.sCurrentGPA * GradeData.sCredEarned;
	GradeData.sGradePointNeeded = (GradeData.sDesiredGPA * GradeData.sCredReq) - GradeData.sGradePointBalance;
	GradeData.sTotalGradePoints = GradeData.sGradePointNeeded + GradeData.sGradePointBalance;
	GradeData.sGPANeeded = GradeData.sGradePointNeeded / GradeData.sCredRemain;
	
	// Find the smaller value: Credits remaining or Credits Required
	HoldMin = Math.min(GradeData.sCredRemain, GradeData.sCredReq);
	// if credits required is less than credits remaining, this is an input error.
	if (HoldMin == GradeData.sCredReq && GradeData.sCredRemain != GradeData.sCredReq){
		ErrorList[ErrorListCtr] = new ErrorItem(sCreditsLit + " Remaining cannot be greater than " + sCreditsLit + " Required.", ""); 
		ErrorListCtr++;}
	// if credits required is equal to credits remaining, this is an input error.
	if (GradeData.sCredRemain == GradeData.sCredReq){
		ErrorList[ErrorListCtr] = new ErrorItem(sCreditsLit + " Remaining should not equal " + sCreditsLit + " Required.  Your GPA would be 0.", ""); 
		ErrorListCtr++;}

	if (iRoundOrTruncate != 'N')
	{
		//round sGpaNeeded to 3 decimals
		HoldNum = RoundNum(GradeData.sGPANeeded, iRounding, true);
		GradeData.sGPANeeded = HoldNum;
	}
	else
	{
		//alert("GPA to work with = " + GradeData.sGPANeeded);
		HoldNum = pad_with_zeros(GradeData.sGPANeeded, 3);
		// N.NNN is what this string must be after calling pad_with_zeros
		// we want the N. + iRounding number of bytes to return.
		iNumberOfDecimals = 2 + iRounding;
		GradeData.sGPANeeded = HoldNum.substring(0, iNumberOfDecimals);
	}

	// if the GPA Needed is greater than 4, it will be impossible for the user to achieve a GPA that high given the credits remaining
	if (GradeData.sGPANeeded > 4){
		ErrorList[ErrorListCtr] = new ErrorItem(Err5, GradeData.sGPANeeded); // Err5 = To achieve your desired GPA, you would need to average higher than a 4.0.
		ErrorListCtr++;}
	// if the GPA Needed is less than 0, it will be impossible for the user to get a GPA that low given the credits remaining
	if (GradeData.sGPANeeded < 0){
		ErrorList[ErrorListCtr] = new ErrorItem(Err6, ""); // Your GPA cannot get that low
		ErrorListCtr++;}
	
	
	//round sGradePointNeeded, sGradePointBalance, sTotalGradePoints to 3 decimals
	HoldNum = RoundNum(GradeData.sGradePointNeeded, 3);
	GradeData.sGradePointNeeded = HoldNum;
	HoldNum = RoundNum(GradeData.sGradePointBalance, 3);
	GradeData.sGradePointBalance = HoldNum;
	HoldNum = RoundNum(GradeData.sTotalGradePoints, 3);
	GradeData.sTotalGradePoints = HoldNum;
	//	If there is are errors, Draw Errors.  Else Draw the Results
	if (ErrorList.length > 0)
		DrawErrorList(ErrorList, "GRAD", sForm, sCreditsLit);
	else
		DrawList(GradeData, "GRAD", sForm, sCreditsLit);
}
////////////////////////////////////////////////////////////////////////////
// CALCULATETERMGPA
// Perform the functions of the Term GPA Calculator 
// Calculate the user's GPA at the end of the term given the user's current information
// plus the information about the incomplete term.
// Inputs:  Form Data from SD2GPTRM (including CurrentGPA, Credits Earned So Far),
//          Number of courses that were displayed to the user,
//          CREDITS literal (for display purposes)
//			Grade Information (letter grades and their values), 
// Output:  If there are input errors: Error array
//          If there are no errors:    Ending GPA, CourseList array to display what the user has input
////////////////////////////////////////////////////////////////////////////
function CalculateTermGPA(sForm, sCreditsLit, iRounding, iRoundOrTruncate)
{
//alert ("CalculateTermGPA enter");
	CourseList = new Array(); // See CourseItem for structure
	ErrorList = new Array();  // See ErrorItem for structure
	ErrorList.length = 0;
	ErrorListCtr = 0;
  FinalArrayCounter = 0;
	// if the Current GPA is not numeric, blank, or greater than 4, then it means an input error occurred
	if (!IsNumeric(sForm.CURRENTGPA.value) || sForm.CURRENTGPA.value == "" || sForm.CURRENTGPA.value > 4)
  {
		ErrorList[ErrorListCtr] = new ErrorItem(Err8, ""); // Err8 = Current GPA is invalid.  Please enter a valid GPA.
		ErrorListCtr++;
  }
	// if the Credits Earned is not numeric or blank, then it means an input error occurred
	if (!IsNumeric(sForm.CREDEARN.value) || sForm.CREDEARN.value == "")
  {
		ErrorList[ErrorListCtr] = new ErrorItem(sCreditsLit + " Earned is invalid.  Please enter valid " + sCreditsLit + " Earned.", "");
		ErrorListCtr++;
  }
	// sCourseCount contains the number of courses that are listed for input. (UCXCFG020 WEB bytes 51:2)
  for (iClassIndex=0; iClassIndex < aClassListArray.length; iClassIndex++)
  {
  	  CourseList[FinalArrayCounter] = 
				new CourseItem(aClassListArray[iClassIndex].iCredits,
								       aClassListArray[iClassIndex].sGrade, 
								       aClassListArray[iClassIndex].sLetterGrade, 
                       aClassListArray[iClassIndex].sNumericGrade, 
								       aClassListArray[iClassIndex].sCourseKey); 
			// Increment the FinalArrayCounter so that the CourseList will be structured properly
			FinalArrayCounter++;
  }
	// if there were no valid Class information entered, this is an error
	if (CourseList.length == 0)
  {
		ErrorList[ErrorListCtr] = new ErrorItem(Err7, "");
		ErrorListCtr++;
  }
	// These 2 could also be derived from the sCourseCount IFF we establish rules for screen structure.
	//sCurrentGPA = sForm.CURRENTGPAFULL.value;
	sCurrentGPA = sForm.CURRENTGPA.value;
	sCreditsSoFar = sForm.CREDEARN.value;
	sGradePointsSoFar = sCurrentGPA * sCreditsSoFar;
	CourseListLength = CourseList.length;
	sTotalCredits = 0;
	sTotalGradePoints = 0;
	// loop through the CourseList, adding the credits to the total number of credits earned (sTotalCredits)
	//                            , adding the grade points to the total number of grade points earned (sTotalGradePoints)
	// (we are trying to determine the user's GPA after factoring in this class information)
  //alert ("Start checking all credits/grades");
  for (CourseListCtr = 0; CourseListCtr < CourseListLength ; CourseListCtr++ )
	{
		// if the Grade is not numeric or if the Grade is greater than 4, this is an error.
		if (!IsNumeric(CourseList[CourseListCtr].gradeNumber) || CourseList[CourseListCtr].gradeNumber > IndividualClassGradeMax)
		{
			ErrorList[ErrorListCtr] = new ErrorItem(Err14, "");
			ErrorListCtr++;
		}
		// if the credits value is not numeric or if the credits value is greater than IndividualClassCreditMax, this is an error.
		else if (!IsNumeric(CourseList[CourseListCtr].credits) || CourseList[CourseListCtr].credits > IndividualClassCreditMax)
		{
			ErrorList[ErrorListCtr] = new ErrorItem('The following invalid ' + sCreditsLit + ' were found: <b>' + CourseList[CourseListCtr].credits + '</b><br /> Please enter valid ' + sCreditsLit + '.', "");
			ErrorListCtr++;
		}
    else // grade number and credits are valid
    {
      sTotalCredits     += Number(CourseList[CourseListCtr].credits);
      sTotalGradePoints += (Number(CourseList[CourseListCtr].credits) * Number(CourseList[CourseListCtr].gradeNumber));
    }
	}
  //alert ("Done checking all credits/grades");
	// add the grade points from the CourseList to the Grade Points earned so far (sGradePointsSoFar)
	sTotalGradePoints += Number(sGradePointsSoFar);
	// add the credits from the CourseList to the Credits Earned so far (sCreditsSoFar)
	sTotalCredits += Number(sCreditsSoFar);
	// GPA = Grade Points / Credits
	sTotalGPA = (sTotalGradePoints / sTotalCredits).toFixed(10); 
	// Round the GPA to 3, padded to iRounding decimal places

	if (iRoundOrTruncate != 'N')
	{
		// Round the GPA to iRounding, padded to iRounding decimal places
		sTotalGPA = RoundNum(sTotalGPA, iRounding, true);
	}
	else
	{
		//alert("GPA to work with = " + sTotalGPA);
		HoldNum = pad_with_zeros(sTotalGPA, 3);
		// N.NNN is what this string must be after calling pad_with_zeros
		// we want the N. + iRounding number of bytes to return.
		iNumberOfDecimals = 2 + iRounding;
		sTotalGPA = HoldNum.substring(0, iNumberOfDecimals);
	}
  //alert ("CalculateTermGPA - before DrawList; ErrorListCtr=" + ErrorListCtr);  
	//	If there is are errors, Draw Errors.  Else Draw the Results
	if (ErrorListCtr > 0)
		DrawErrorList(ErrorList, "TERM", sForm, sCreditsLit);
	else
		DrawList(sTotalGPA, "TERM", sForm, sCreditsLit, CourseList);
}
////////////////////////////////////////////////////////////////////////////
// CALCULATEADVICEGPA
// Perform the functions of the Advice GPA Calculator 
// Calculate the different combinations of grade point averages needed to
// achieve the desired GPA.
// Inputs:  Form Data from SD2GPAADV (including Current GPA, Credits Earned, Desired GPA), 
//          Grade Information (specifically Grade Points), 
//          CREDITS literal (for display purposes)
// Output:  If there are input errors: Error array
//          If there are no errors:    ResultList (array of different combinations of grade point averages)
////////////////////////////////////////////////////////////////////////////
function CalculateAdviceGPA(sForm, sGradePicklist, sCreditsLit, iRounding, iRoundOrTruncate)
{
//alert ("CalculateAdviceGPA enter CREDITEARN");
	var GradeData  = new Array();
	var ErrorList  = new Array();
	ResultList = new Array();
	var HoldNum;
	ErrorList.ErrOther = "";
	ErrorListCtr = 0;
	ErrorList.length = 0;
	GradeData.length = 0;
	//GradeData.sCurrentGPA = sForm.CURRENTGPAFULL.value;
	GradeData.sCurrentGPA = sForm.CURRENTGPA.value;
	GradeData.sCredEarned = sForm.CREDEARN.value;
	GradeData.sDesiredGPA = sForm.DESIREDGPA.value;
	if (!IsNumeric(GradeData.sCurrentGPA)){
		ErrorList[ErrorListCtr] = new ErrorItem(Err8, "");
		ErrorListCtr++;}
	if (!IsNumeric(GradeData.sCredEarned)){
		ErrorList[ErrorListCtr] = new ErrorItem(sCreditsLit + " Earned is invalid.  Please enter valid " + sCreditsLit + " Earned.", "");
		ErrorListCtr++;}
	if (!IsNumeric(GradeData.sDesiredGPA)){
		ErrorList[ErrorListCtr] = new ErrorItem(Err11, "");
		ErrorListCtr++;}
	// Total Grade Points Earned So Far
	GradeData.sGradePointBalance = GradeData.sCurrentGPA * GradeData.sCredEarned;
//alert ("CalculateAdviceGPA GradeData.sGradePointBalance=" +  GradeData.sGradePointBalance);
//alert ("CalculateAdviceGPA GradeData.sCredEarned=" +  GradeData.sCredEarned);
//alert ("CalculateAdviceGPA GradeData.sCurrentGPA=" +  GradeData.sCurrentGPA);
	CreditsNeeded = 0;
	ResultListCtr = 0;
//alert ("CalculateAdviceGPA before FOR; length = " + sGradePicklist.length);	
	GradelistCtr = 0;
	for (GradelistCtr = 0; GradelistCtr < sGradePicklist.length && sGradePicklist[GradelistCtr].numericGrade >= 0 ; GradelistCtr++ )
	{
    //alert ("Numeric grade = " + sGradePicklist[GradelistCtr].numericGrade);
		CreditsNeeded = (GradeData.sGradePointBalance - (GradeData.sDesiredGPA * GradeData.sCredEarned)) / 
			            (GradeData.sDesiredGPA - sGradePicklist[GradelistCtr].numericGrade);
    //alert ("CreditsNeeded = " + CreditsNeeded);                  
		if (sGradePicklist[GradelistCtr].numericGrade <= GradeData.sDesiredGPA && GradeData.sDesiredGPA > GradeData.sCurrentGPA)
		{
//alert ("breaking out of for loop");
			break;
		}
        // By rounding down the CreditsNeeded we end up with incorrect results; we need to round up so that the student 
        // ends up with at least the GPA desired - but usually a bit more.
        CreditsNeeded = Math.ceil(CreditsNeeded);  // ceiling function
//alert ("CalculateAdviceGPA numericGrade=" + sGradePicklist[GradelistCtr].numericGrade +
       //"; preRound=" + preCreditsNeeded + "; postRound=" + CreditsNeeded);    
		if (CreditsNeeded > 0 && CreditsNeeded <= iCredMax)
		{
            numericGrade = RoundNum(sGradePicklist[GradelistCtr].numericGrade, iRounding, true);
//alert ("CalculateAdviceGPA pre-numericGrade=" + sGradePicklist[GradelistCtr].numericGrade +
  //     "; post-numericGrade=" + numericGrade);                
			ResultList[ResultListCtr] = new ResultItem(CreditsNeeded, numericGrade, sGradePicklist[GradelistCtr].grade, sCreditsLit);
			ResultListCtr++;
		}
	}
  //alert ("Result list length = " + ResultList.length);    
	if (ResultList.length == 0)
    {			// CMU customized error message 1!!
		ErrorList[ErrorListCtr] = new ErrorItem("  Please use the Term Calculator to estimate what your GPA will be at the end of the Term.", "");
		ErrorListCtr++;
    }
//alert ("Calling DrawList");    
	////////////////////////////////////////
	//	Draw Either the Results or the Errors
	if (ErrorList.length > 0)
		DrawErrorList(ErrorList, "ADV", sForm, sCreditsLit);
	else
		DrawList(ResultList, "ADV", sForm, sCreditsLit);
	////////////////////////////////////////
}

///////////////////////////////////////////////////////////////////////////////
// DRAWLIST
// Draws the results to the frBody frame.
///////////////////////////////////////////////////////////////////////////////
function DrawList(GradeData, FormType, sForm, sCreditsLit, CourseList) 
{
//alert ("DrawList enter");
// Instead of going back we will go forward to a new page
var sGoBackFunction = "<script>function goBack(){" +
                      "document.frmGPA.submit();}</script>";
if (FormType == "GRAD")
{
	 CurrentGPA = sForm.CURRENTGPA.value;
	 CredRemain = sForm.CREDREMAIN.value;
	 CredReq    = sForm.CREDREQ.value;
	 DesiredGPA = sForm.DESIREDGPA.value;
     with(parent.frBody.document) {
             open();
             writeln('<html>');
             writeln('<head><title>GPA Graduation Calculator</title><link rel=StyleSheet href="DGW_Style.css" type="text/css">');
			 writeln('</head>');
       writeln(sGoBackFunction);
       writeln('<body class="GPABodyBackground">');
       writeln('<form name="frmGPA">');
       writeln('<table border="0" cellspacing="0" cellpadding="0" width="35%" align="center">');
			// hidden values begin
			writeln('<input type="hidden" name="SCRIPT"        value="SD2GPAFRM">');
			writeln('<input type="hidden" name="NEXTFORM"      value="1STPAGE">');
			writeln('<input type="hidden" name="CURRENTGPA" value="' + CurrentGPA + '">');
			writeln('<input type="hidden" name="DESIREDGPA" value="' + DesiredGPA + '">');
			writeln('<input type="hidden" name="CREDEARN"   value="">');
			writeln('<input type="hidden" name="CREDREMAIN" value="' + CredRemain + '">');
			writeln('<input type="hidden" name="CREDREQ"    value="' + CredReq + '">');
			// hidden values end
			// inputted values display begin
			 writeln('<tr><td class="GPATableDataMessageLeft" colspan="2"><br /></td></tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln('Current GPA');
               writeln('</td>');
               writeln('<td class="GPATableDataMessageRight">');
               writeln(CurrentGPA);
               writeln('</td>');
             writeln('</tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln(sCreditsLit + ' Remaining');
               writeln('</td>');
               writeln('<td class="GPATableDataMessageRight">');
               writeln(CredRemain);
               writeln('</td>');
             writeln('</tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln(sCreditsLit + ' Required');
               writeln('</td>');
               writeln('<td class="GPATableDataMessageRight">');
               writeln(CredReq);
               writeln('</td>');
             writeln('</tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln('Desired GPA');
               writeln('</td>');
               writeln('<td class="GPATableDataMessageRight">');
               writeln(DesiredGPA);
               writeln('</td>');
             writeln('</tr>');
			 // inputted values display end
             writeln('<tr><td class="GPATableDataMessageLeft" colspan="2"><br /></td></tr>');
			 writeln('</table>');
             writeln('<table border="0" cellspacing="0" cellpadding="0" width="50%" align="center">');
			writeln('<tr>');
			writeln('<td class="GPAResultHR">');
			writeln('<img src="Images_DG2/spacer.gif" height=2><br>');
			writeln('</td>');
			writeln('</tr>');
			 writeln('<tr><td class="GPAGradResultsTable"><br /></td></tr>');
             writeln('<tr>');
               writeln('<td class="GPAGradResultsTable">');
               writeln('You need to average a ' + GradeData.sGPANeeded + ' over your final ');
               writeln(GradeData.sCredRemain + ' ' +  GradeData.sCreditsLit + ' to graduate with your desired GPA.');
               writeln('</td>');
             writeln('</tr>');
             writeln('<tr><td class="GPAGradResultsTable"><br /></td></tr>');
			writeln('<tr>');
			writeln('<td class="GPAResultHR">');
			writeln('<img src="Images_DG2/spacer.gif" height=2><br>');
			writeln('</td>');
			writeln('</tr>');
			
			writeln('<tr>');
			writeln('<td align="center">');
			writeln('<img src="Images_DG2/spacer.gif" height=2><br><br>');
			writeln('<input type=button name=LOAD id=LOAD value="Recalculate" onClick="goBack();">');
			writeln('</td>');
			writeln('</tr>');
			
			writeln('</table>');
			// Advice End
      writeln('</table>');
 
			writeln('</form></body>');
            writeln('</html>');
            close();
        }
}
if (FormType == "TERM")
{
	 CurrentGPA = sForm.CURRENTGPA.value;
	 CredEarn   = sForm.CREDEARN.value;
	 CourseListLength = CourseList.length;
   sSchool = sForm.SCHOOL.value;
	 
	 DisplayCourseArray = new Array();
	 for (DisplayCourseCtr = 0; DisplayCourseCtr < CourseListLength ; DisplayCourseCtr++ )
	 {
		DisplayCourseArray[DisplayCourseCtr] = 
     new DisplayCourseItem (CourseList[DisplayCourseCtr].credits, 
			 		 								  CourseList[DisplayCourseCtr].gradeNumber, 
				 									  CourseList[DisplayCourseCtr].gradeLetter,
													  CourseList[DisplayCourseCtr].courseKey);
	 }
	 DisplayListLength = DisplayCourseArray.length;
	 with(parent.frBody.document) 
   {
      open();
      writeln('<html>');
      writeln('<head><title>GPA Term Calculator</title>');
      writeln('<link rel=StyleSheet href="DGW_Style.css" type="text/css">');
			writeln('</head>');
      //writeln(sGoBackFunction);
			writeln('<body class="GPABodyBackground">');
      writeln('<form name="frmGPA">');
			// hidden values begin
			writeln('<input type="hidden" name="SCRIPT"        value="SD2GPATRM">');
			writeln('<input type="hidden" name="NEXTFORM"      value="2NDTIME">');
			writeln('<input type="hidden" name="STUID"      value="">');
			writeln('<input type="hidden" name="CURRENTGPA" value="' + CurrentGPA + '">');
			writeln('<input type="hidden" name="CREDEARN"   value="' + CredEarn + '">');
			writeln('<input type="hidden" name="SCHOOL"     value="' + sSchool + '">');
      // Send the courses back to the first page to redisplay them
      for ( CourseIndex = 0 ; CourseIndex < DisplayListLength ;  CourseIndex++ )
			{
				if (DisplayCourseArray[CourseIndex].courseKey != "")
        {
          CourseNumber = CourseIndex + 1; // start with 1 instead of 0
          // TODO: need to put quotes around the course in case it has a & char
          writeln(' <input type="hidden" name="COURSE'  + CourseNumber + '" value="' + DisplayCourseArray[CourseIndex].courseKey + '">');
          writeln(' <input type="hidden" name="CREDITS' + CourseNumber + '" value="' + DisplayCourseArray[CourseIndex].credits   + '">');
          writeln(' <input type="hidden" name="GRADE'   + CourseNumber + '" value="' + DisplayCourseArray[CourseIndex].gradeLetter + '">');
        }
      }
			
			writeln('<table width="100%" border="0">');
			writeln('<tr>');
			writeln('<td align=left valign=top width="10"><img src="Images_DG2/spacer.gif" width="15" height="1"></td>');
			writeln('<td align=left valign=top width="100%" style="line-height: normal;"><br>');
			writeln('  <table width="35%" border="0" align="left" summary="Your Current Information">');
			writeln('    <tr> ');
			writeln('      <td width="66%" class="GPATermCurrentCellLeft"><strong>Current ');
			writeln('        GPA</strong></td>');
			writeln('      <td width="34%" class="GPATermCurrentCellRight"> ' + CurrentGPA + ' </td>');
			writeln('    </tr>');
			writeln('    <tr> ');
			writeln('      <td class="GPATermCurrentCellLeft"><strong> ' + sCreditsLit + 'Earned So Far</strong></td>');
			writeln('      <td class="GPATermCurrentCellRight"> ' + CredEarn + ' </td>');
			writeln('    </tr>');
			writeln('  </table>');
			writeln('  <br />');
			writeln('  <br />');
			writeln('  <br />');
			writeln('  <br />');
			writeln('  <table width="42%" border="1" align="left" cellpadding="1" summary="Your Class Information">');
			writeln('    <tr> ');
			writeln('      <th width="35%" class="GPATermProspectiveHeader"><strong>Class</strong></td> ');
			writeln('      <th width="17%" class="GPATermProspectiveHeaderCenter"> ' + sCreditsLit + '</td> ');
			writeln('      <th width="48%" class="GPATermProspectiveHeaderCenter">Grade</td> </tr>');
			for ( DisplayCourseCtr = 0 ; 
            DisplayCourseCtr < DisplayListLength ; 
            DisplayCourseCtr++ )
			{
				writeln('    <tr> ');
				if (DisplayCourseArray[DisplayCourseCtr].courseKey == "")
				writeln('      <td class="GPATermProspectiveCell"><strong> Class </strong></td>');
				else
				writeln('      <td class="GPATermProspectiveCell"><strong>' + DisplayCourseArray[DisplayCourseCtr].courseKey + '</strong></td>');
				writeln('      <td class="GPATermProspectiveCellCenter">' + DisplayCourseArray[DisplayCourseCtr].credits + '</td>');
				writeln('      <td class="GPATermProspectiveCell"> <table width="100%" border="0">');
				writeln('          <tr> ');
				if (DisplayCourseArray[DisplayCourseCtr].gradeLetter != "NOLETTERGRADE")
				{
					writeln('            <td width="40%" class="GPATermProspectiveCellCenter"> ' + DisplayCourseArray[DisplayCourseCtr].gradeLetter + '</td>');
					writeln('            <td width="60%" class="GPATermProspectiveCellCenter"> ' + DisplayCourseArray[DisplayCourseCtr].gradeNumber + '</td>');
				}
				else
				{
					writeln('            <td colspan="2" class="GPATermProspectiveCellCenter"> ' + DisplayCourseArray[DisplayCourseCtr].gradeNumber + '</td>');
				}
				writeln('          </tr>');
				writeln('        </table></td>');
				writeln('    </tr>');
			}
			writeln('  </table>');
      
			writeln('  <table width="42%" border="0" align="left" cellpadding="3" summary="Your Results">');
			writeln('    <tr> ');
			writeln('      <td width="53%" class="GPATermResultCellSmall"><table width="100%" border="0" align="left" cellpadding="0" cellspacing="0">');
			writeln('          <tr> ');
			writeln('            <td width="83%" class="GPATermResultCellBig">Calculated GPA</td>');
			writeln('            <td width="17%" class="GPATermResultCellBig">' + GradeData + '</td>');
			writeln('          </tr>');
			writeln('        </table></td>');
			writeln('    </tr>');
			writeln('    <tr> ');
			writeln('      <td width="53%" class="GPATermResultCellSmall">');
			writeln('				By achieving the grades listed here, your <br />');
			writeln('				GPA at the end of the term will be ' + GradeData + '</td>');
			writeln('    </tr>');
			writeln('    <tr> ');
			writeln('      <td width="53%" align="center">');
      // The goBack does not work for some reason so just submit the form directly
			//writeln('		<br /><input type=button name=LOAD id=LOAD value="RecalculateXX" onClick="goBack();">');
			writeln('		<br /><input type="submit" name=LOAD id=LOAD value="Recalculate" >');
			writeln('    </tr>');
			writeln('  </table>');
			writeln('</td>');
			writeln('</tr>');
			writeln('</table>');
			writeln('</form></body>');
			writeln('</html>');
			close();
        }
}
if (FormType == "ADV")
{
	 CurrentGPA = sForm.CURRENTGPA.value;
	 CredEarn   = sForm.CREDEARN.value;
	 DesiredGPA = sForm.DESIREDGPA.value;
     sSchool = sForm.SCHOOL.value;
	 with(parent.frBody.document) {
             open();
             writeln('<html>');
             writeln('<head><title>GPA Advice Calculator</title><link rel=StyleSheet href="DGW_Style.css" type="text/css">');
			writeln('</head>');
      writeln(sGoBackFunction);
             writeln('<body class="GPABodyBackground">');
             writeln('<form name="frmGPA">');
			// hidden values begin
			writeln('<input type="hidden" name="SERVICE"       value="SCRIPTER">');
			writeln('<input type="hidden" name="SCRIPT"        value="SD2GPAADV">');
			writeln('<input type="hidden" name="NEXTFORM"      value="1STPAGE">');
			writeln('<input type="hidden" name="CURRENTGPA" value="' + CurrentGPA + '">');
			writeln('<input type="hidden" name="DESIREDGPA" value="' + DesiredGPA + '">');
			writeln('<input type="hidden" name="CREDEARN"   value="' + CredEarn + '">');
			writeln('<input type="hidden" name="SCHOOL"     value="' + sSchool + '">');
      writeln('<table border="0" cellspacing="0" cellpadding="0" width="20%" align="center">');
			// hidden values end
			// inputted values display begin
			 writeln('<tr><td class="GPATableDataMessageLeft" colspan="2"><br /></td></tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln('Current GPA');
               writeln('</td>');
               writeln('<td class="GPATableDataMessageRight">');
               writeln(CurrentGPA);
               writeln('</td>');
             writeln('</tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln(sCreditsLit + ' Earned');
               writeln('</td>');
               writeln('<td class="GPATableDataMessageRight">');
               writeln(CredEarn);
               writeln('</td>');
             writeln('</tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln('Desired GPA');
               writeln('</td>');
               writeln('<td class="GPATableDataMessageRight">');
               writeln(DesiredGPA);
               writeln('</td>');
             writeln('</tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln('<br />');
               writeln('</td>');
             writeln('</tr>');
			 // inputted values display end
			writeln('</table>');
             writeln('<table border="0" cellspacing="0" cellpadding="3" width="100%">');
			// Advice begin
			writeln('<tr>');
               writeln('<td colspan="2" class="GPATableDataMessageCenter">');
               writeln('To achieve your desired GPA, you need one of the following:<br>');
               writeln('</td>');
             writeln('</tr>');
			writeln('<tr>');
			writeln('<td class="GPAResultHR">');
			writeln('<img src="Images_DG2/spacer.gif" height=2><br>');
			writeln('</td>');
			writeln('</tr>');
			for (ResultListCtr = 0; ResultListCtr < ResultList.length ; ResultListCtr++ )
			{
				writeln('<tr>');
				  writeln('<td class="GPATableDataMessageLeft" colspan="2">');
				  writeln(ResultList[ResultListCtr].credits + ' ' + ResultList[ResultListCtr].lit + ' at ');
				  writeln(ResultList[ResultListCtr].average + ' ( ' + ResultList[ResultListCtr].grade + ' ) grade average');
				  writeln('</td>');
				writeln('</tr>');
			}
             writeln('</table>');
			// Advice End
             writeln('<table border="0" cellspacing="0" cellpadding="3" width="100%">');
			writeln('<tr>');
			writeln('<td class="GPAResultHR">');
			writeln('<img src="Images_DG2/spacer.gif" height=2><br>');
			writeln('</td>');
			writeln('</tr>');
			
			// Note Begin
			writeln('<tr>');
               writeln('<td colspan="2" class="GPATableDataMessageLeft">');
               writeln('Note: Results that would require you to take more than ' + iCredMax + ' ' + ResultList[0].lit + ' have been omitted.');
               writeln('</td>');
             writeln('</tr>');
			// Note End
			writeln('<tr>');
			writeln('<td align="center">');
			writeln('<img src="Images_DG2/spacer.gif" height=2><br><br>');
			//writeln('<input type=button name=LOAD id=LOAD value="Recalculate" onClick="goBack();">');
  		writeln('		<br /><input type="submit" name=LOAD id=LOAD value="Recalculate" xonClick="goBack();">');
      writeln('</td>');
			writeln('</tr>');
			writeln('</table>');
      writeln('</form></body>');
      writeln('</html>');
      close();
        }
}
}
///////////////////////////////////////////////////////////////////////////////
// DRAWERRORLIST
// Draws the error details to the frBody frame.
///////////////////////////////////////////////////////////////////////////////
function DrawErrorList(ErrorList, FormType, sForm, sCreditsLit) 
{
// In IE, we will go back 2 pages while in Chrome it will only
// bring us back 1 page - because the page that is drawn is not really a new page;
// that is, in Chrome this new page we create does not increment the history.length
var sGoBackFunction = "<script>function goBack(){" +
                      "document.frmGPA.submit();}</script>";
if (FormType == "GRAD")
{
	 CurrentGPA = sForm.CURRENTGPA.value;
	 CredRemain = sForm.CREDREMAIN.value;
	 CredReq    = sForm.CREDREQ.value;
	 DesiredGPA = sForm.DESIREDGPA.value;
	with(parent.frBody.document) {
       open();
       writeln('<html>');
       writeln('<head><title>GPA Calculator</title><link rel=StyleSheet href="DGW_Style.css" type="text/css">');
       writeln('</head>');
       writeln(sGoBackFunction);
       writeln('<body class="GPABodyBackground">');
       writeln('<form name="frmGPA">');
       writeln('<table border="0" cellspacing="0" cellpadding="0" width="100%">');
       writeln('<tr>');
       writeln('<td align="left" valign="top">');
       writeln('<table border="0" cellspacing="0" cellpadding="3" width="100%">');
		writeln('<tr>');
		writeln('<td align="middle" valign="middle">');
			// hidden values begin
			writeln('<input type="hidden" name="SCRIPT"        value="SD2GPAFRM">');
			writeln('<input type="hidden" name="NEXTFORM"      value="1STPAGE">');
			writeln('<input type="hidden" name="CURRENTGPA" value="' + CurrentGPA + '">');
			writeln('<input type="hidden" name="DESIREDGPA" value="' + DesiredGPA + '">');
			writeln('<input type="hidden" name="CREDEARN"   value="">');
			writeln('<input type="hidden" name="CREDREMAIN" value="' + CredRemain + '">');
			writeln('<input type="hidden" name="CREDREQ"    value="' + CredReq + '">');
			// hidden values end
      writeln('<table border="0" cellspacing="0" cellpadding="0" width="35%" align="center">');
 
		writeln('<tr>');
		writeln('<td>');
		writeln('<br></td>');
		writeln('<td>');
		writeln('</td>');
		writeln('</tr>');
			// inputted values display begin
			 writeln('<tr><td class="GPATableDataMessageLeft" colspan="2"><br /></td></tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln('Current GPA');
               writeln('</td>');
               writeln('<td class="GPATableDataMessageRight">');
               writeln(CurrentGPA);
               writeln('</td>');
             writeln('</tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln(sCreditsLit + ' Remaining');
               writeln('</td>');
               writeln('<td class="GPATableDataMessageRight">');
               writeln(CredRemain);
               writeln('</td>');
             writeln('</tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln(sCreditsLit + ' Required');
               writeln('</td>');
               writeln('<td class="GPATableDataMessageRight">');
               writeln(CredReq);
               writeln('</td>');
             writeln('</tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln('Desired GPA');
               writeln('</td>');
               writeln('<td class="GPATableDataMessageRight">');
               writeln(DesiredGPA);
               writeln('</td>');
             writeln('</tr>');
			 // inputted values display end
			writeln('</table>');
       writeln('<table border="0" cellspacing="0" cellpadding="0" width="100%">');
 
		writeln('<tr>');
		writeln('<td>');
		writeln('<br></td>');
		writeln('<td>');
		writeln('</td>');
		writeln('</tr>');
	for (ErrorListCtr = 0; ErrorListCtr < ErrorList.length ; ErrorListCtr++ )
	{
		if (ErrorList[ErrorListCtr].ErrorOther != "")
		{
			writeln('<tr>');
			writeln('<td class="GPAErrorLabel">');
			writeln('Error: ');
			writeln('</td>');
			writeln('<td class="GPAErrorData">');
			writeln(ErrorList[ErrorListCtr].ErrorNum + '<b>' + ErrorList[ErrorListCtr].ErrorOther + '</b>.');
			writeln('</td>');
			writeln('</tr>');
		}
		else{
			writeln('<tr>');
			writeln('<td class="GPAErrorLabel">');
			writeln('Error: ');
			writeln('</td>');
			writeln('<td class="GPAErrorData">');
			writeln(ErrorList[ErrorListCtr].ErrorNum);
			writeln('</td>');
			writeln('</tr>');
		}
	}
	   writeln('</table>');
       writeln('<table border="0" cellspacing="0" cellpadding="0" width="100%">');
			writeln('<tr>');
			writeln('<td align="center">');
			writeln('<img src="Images_DG2/spacer.gif" height=2><br><br>');
			writeln('<input type=button name=LOAD id=LOAD value="Recalculate" onClick="goBack();">');
			writeln('</td>');
			writeln('</tr>');
       writeln('</table></form></body>');
       writeln('</html>');
       close();
		}
}
else if (FormType == "TERM")
{
	 CurrentGPA = sForm.CURRENTGPA.value;
	 CredEarn   = sForm.CREDEARN.value;
   sSchool = sForm.SCHOOL.value;
   DisplayCourseArray = new Array();
	 for (DisplayCourseCtr = 0; DisplayCourseCtr < CourseListLength ; DisplayCourseCtr++ )
	 {
		DisplayCourseArray[DisplayCourseCtr] = 
     new DisplayCourseItem (CourseList[DisplayCourseCtr].credits, 
			 		 								  CourseList[DisplayCourseCtr].gradeNumber, 
				 									  CourseList[DisplayCourseCtr].gradeLetter,
													  CourseList[DisplayCourseCtr].courseKey);
	 }
	 DisplayListLength = DisplayCourseArray.length;
	 with(parent.frBody.document) 
   {
       open();
       writeln('<html>');
       writeln('<head><title>GPA Calculator</title><link rel=StyleSheet href="DGW_Style.css" type="text/css">');
	   writeln('</head>');
     writeln(sGoBackFunction);
       writeln('<body class="GPABodyBackground">');
       writeln('<form name="frmGPA">');
			// hidden values begin
			writeln('<input type="hidden" name="SCRIPT"        value="SD2GPATRM">');
			writeln('<input type="hidden" name="NEXTFORM"      value="2NDTIME">');
			writeln('<input type="hidden" name="STUID"      value="">');
			writeln('<input type="hidden" name="CURRENTGPA" value="' + CurrentGPA + '">');
			writeln('<input type="hidden" name="CREDEARN"   value="' + CredEarn + '">');
			writeln('<input type="hidden" name="SCHOOL"     value="' + sSchool + '">');
      
      // Send the courses back to the first page to redisplay them when user clicks Recalculate
      for ( CourseIndex = 0 ; CourseIndex < DisplayListLength ;  CourseIndex++ )
			{
				if (DisplayCourseArray[CourseIndex].courseKey != "")
        {
          CourseNumber = CourseIndex + 1; // start with 1 instead of 0
          // TODO: need to put quotes around the course in case it has a & char
          writeln(' <input type="hidden" name="COURSE'  + CourseNumber + '" value="' + DisplayCourseArray[CourseIndex].courseKey + '">');
          writeln(' <input type="hidden" name="CREDITS' + CourseNumber + '" value="' + DisplayCourseArray[CourseIndex].credits   + '">');
          writeln(' <input type="hidden" name="GRADE'   + CourseNumber + '" value="' + DisplayCourseArray[CourseIndex].gradeLetter + '">');
        }
      }
      
    writeln('<table border="0" cellspacing="0" cellpadding="0" width="40%" align="center">');
		writeln('<tr>');
		writeln('<td>');
		writeln('<br></td>');
		writeln('<td>');
		writeln('</td>');
		writeln('</tr>');
			// inputted values display begin
			 writeln('<tr><td class="GPATableDataMessageLeft" colspan="2"><br /></td></tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln('Current GPA');
               writeln('</td>');
               writeln('<td class="GPATableDataMessageRight">');
               writeln(CurrentGPA);
               writeln('</td>');
             writeln('</tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln(sCreditsLit + ' Earned');
               writeln('</td>');
               writeln('<td class="GPATableDataMessageRight">');
               writeln(CredEarn);
               writeln('</td>');
             writeln('</tr>');
			 // inputted values display end
			writeln('</table>');
	   
	   writeln('<table border="0" cellspacing="0" cellpadding="0" width="100%">');
 
		writeln('<tr>');
		writeln('<td>');
		writeln('<br></td>');
		writeln('<td>');
		writeln('</td>');
		writeln('</tr>');
	for (ErrorListCtr = 0; ErrorListCtr < ErrorList.length ; ErrorListCtr++ )
	{
		writeln('<tr>');
		writeln('<td class="GPAErrorLabel">');
		writeln('Error: ');
		writeln('</td>');
		writeln('<td class="GPAErrorData">');
		writeln(ErrorList[ErrorListCtr].ErrorNum);
		writeln('</td>');
		writeln('</tr>');
		if (ErrorList[ErrorListCtr].ErrorOther != "")
		{
			writeln('<tr>');
			writeln('<td class="GPAErrorLabel">');
			writeln('Error: ');
			writeln('</td>');
			writeln('<td class="GPAErrorData">');
			writeln('<b>' + ErrorList[ErrorListCtr].ErrorOther + '</b>.');
			writeln('</td>');
			writeln('</tr>');
		}
	}
		writeln('<tr>');
		writeln('<td>');
		writeln('<br></td>');
		writeln('<td>');
		writeln('</td>');
		writeln('</tr>');
	   writeln('</table>');
       writeln('<table border="0" cellspacing="0" cellpadding="0" width="100%">');
			writeln('<tr>');
			writeln('<td align="center">');
			writeln('<img src="Images_DG2/spacer.gif" height=2><br><br>');
			writeln('<input type=submit name=LOAD id=LOAD value="Recalculate">');
			writeln('</td>');
			writeln('</tr>');
       writeln('</table></form></body>');
       writeln('</html>');
       close();
		}
}
else if (FormType == "ADV")
{
	 CurrentGPA = sForm.CURRENTGPA.value;
	 CredEarn   = sForm.CREDEARN.value;
	 DesiredGPA = sForm.DESIREDGPA.value;
     sSchool = sForm.SCHOOL.value;
	with(parent.frBody.document) {
       open();
       writeln('<html>');
       writeln('<head><title>GPA Calculator</title><link rel=StyleSheet href="DGW_Style.css" type="text/css">');
	   writeln('</head>');
     writeln(sGoBackFunction);
       writeln('<body class="GPABodyBackground">');
       writeln('<form name="frmGPA">');
       writeln('<table border="0" cellspacing="0" cellpadding="0" width="100%">');
       writeln('<tr>');
       writeln('<td align="left" valign="top">');
       writeln('<table border="0" cellspacing="0" cellpadding="3" width="100%">');
		writeln('<tr>');
		writeln('<td align="middle" valign="middle">');
			// hidden values begin
			writeln('<input type="hidden" name="SERVICE"       value="SCRIPTER">');
			writeln('<input type="hidden" name="SCRIPT"        value="SD2GPAADV">');
			writeln('<input type="hidden" name="NEXTFORM"      value="1STPAGE">');
			writeln('<input type="hidden" name="CURRENTGPA" value="' + CurrentGPA + '">');
			writeln('<input type="hidden" name="DESIREDGPA" value="' + DesiredGPA + '">');
			writeln('<input type="hidden" name="CREDEARN"   value="' + CredEarn + '">');
			writeln('<input type="hidden" name="SCHOOL"     value="' + sSchool + '">');
			// hidden values end
       writeln('<table border="0" cellspacing="0" cellpadding="0" width="40%" align="center">');
 
		writeln('<tr>');
		writeln('<td>');
		writeln('<br></td>');
		writeln('<td>');
		writeln('</td>');
		writeln('</tr>');
			// inputted values display begin
			 writeln('<tr><td class="GPATableDataMessageLeft" colspan="2"><br /></td></tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln('Current GPA');
               writeln('</td>');
               writeln('<td class="GPATableDataMessageRight">');
               writeln(CurrentGPA);
               writeln('</td>');
             writeln('</tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln(sCreditsLit + ' Earned');
               writeln('</td>');
               writeln('<td class="GPATableDataMessageRight">');
               writeln(CredEarn);
               writeln('</td>');
             writeln('</tr>');
             writeln('<tr>');
               writeln('<td class="GPATableDataMessageLeft">');
               writeln('Desired GPA');
               writeln('</td>');
               writeln('<td class="GPATableDataMessageRight">');
               writeln(DesiredGPA);
               writeln('</td>');
             writeln('</tr>');
			 // inputted values display end
			writeln('</table>');
       writeln('<table border="0" cellspacing="0" cellpadding="0" width="100%">');
 
		writeln('<tr>');
		writeln('<td class="GPAErrorLabel">');
		writeln('<br></td>');
		writeln('<td class="GPAErrorData">');
		writeln('</td>');
		writeln('</tr>');
		for (ErrorListCtr = 0; ErrorListCtr < ErrorList.length ; ErrorListCtr++ )
		{
			if (ErrorList[ErrorListCtr].ErrorOther != "")
			{
				writeln('<tr>');
				writeln('<td class="GPAErrorLabel">');
				writeln('Error: ');
				writeln('</td>');
				writeln('<td class="GPAErrorData">');
				writeln(ErrorList[ErrorListCtr].ErrorNum + '<b>' + ErrorList[ErrorListCtr].ErrorOther + '</b>.');
				writeln('</td>');
				writeln('</tr>');
			}
			else{
				writeln('<tr>');
				writeln('<td class="GPAErrorLabel">');
				writeln('Error: ');
				writeln('</td>');
				writeln('<td class="GPAErrorData">');
				writeln(ErrorList[ErrorListCtr].ErrorNum);
				writeln('</td>');
				writeln('</tr>');
			}
		}
	   writeln('</table>');
       writeln('<table border="0" cellspacing="0" cellpadding="0" width="100%">');
			writeln('<tr>');
			writeln('<td align="center">');
			writeln('<img src="Images_DG2/spacer.gif" height=2><br><br>');
			writeln('<input type=button name=LOAD id=LOAD value="Recalculate" onClick="goBack();">');
			writeln('</td>');
			writeln('</tr>');
       writeln('</table></form></body>');
       writeln('</html>');
       close();
	}
}
}
///////////////////////////////////////////////////////////////////////////////
// ISNUMERIC
// Evaluates a string to see if it is numeric; returns true/false
///////////////////////////////////////////////////////////////////////////////
function IsNumeric(strString)
{
   var strValidChars = "0123456789.-";
   var strChar;
   var blnResult = true;
   if (strString.length == 0) return false;
   for (i = 0; i < strString.length && blnResult == true; i++)
      {
      strChar = strString.charAt(i);
      if (strValidChars.indexOf(strChar) == -1)
         {
         blnResult = false;
         }
      }
   return blnResult;
   }
///////////////////////////////////////////////////////////////////////////////
// CHECKNUMERIC
// Checks if a field is numeric.  If not, it'll send back an alert, blank out the
// field, and focus on the field.
///////////////////////////////////////////////////////////////////////////////
function CheckNumeric(strString)
{
	//  check for valid numeric strings	onChange
	if (!IsNumeric(strString.value) && strString.value != "")
	{
		alert("Please enter numeric values only.");
		strString.value = "";
		strString.select();
		strString.focus();
	}
}
///////////////////////////////////////////////////////////////////////////////
// ROUNDNUM
// Rounds a number to the specified number of decimals, and if 'pad' is true,
// it will pad it with the specified number of decimals.
///////////////////////////////////////////////////////////////////////////////
function RoundNum(original_number, decimals, pad) 
{
    var result1 = original_number * Math.pow(10, decimals)
    var result2 = Math.round(result1)
    var result3 = result2 / Math.pow(10, decimals)
	if (pad == true)
		return pad_with_zeros(result3, decimals);
	else
		return result3;
}
///////////////////////////////////////////////////////////////////////////////
// ROUNDDOWN
// Rounds a number down.  Used in the ADVICE calculator
///////////////////////////////////////////////////////////////////////////////
function RoundDown(sString)
{
	HoldString = sString;
	sString = RoundNum(sString, 0)
	if (sString > HoldString)
	{
		sString--;
	}
	return sString;
}
///////////////////////////////////////////////////////////////////////////////
// PAD_WITH_ZEROS
// Takes a value, pads it with zeros to using decimal_places as a guide
///////////////////////////////////////////////////////////////////////////////
function pad_with_zeros(rounded_value, decimal_places) 
{
    // Convert the number to a string
    var value_string = rounded_value.toString()
    
    // Locate the decimal point
    var decimal_location = value_string.indexOf(".")
    // Is there a decimal point?
    if (decimal_location == -1) {
        
        // If no, then all decimal places will be padded with 0s
        decimal_part_length = 0
        
        // If decimal_places is greater than zero, tack on a decimal point
        value_string += decimal_places > 0 ? "." : ""
    }
    else {
        // If yes, then only the extra decimal places will be padded with 0s
        decimal_part_length = value_string.length - decimal_location - 1
    }
    
    // Calculate the number of decimal places that need to be padded with 0s
    var pad_total = decimal_places - decimal_part_length
    
    if (pad_total > 0) {
        
        // Pad the string with 0s
        for (var counter = 1; counter <= pad_total; counter++) 
            value_string += "0"
        }
    return value_string
}
///////////////////////////////////////////////////////////////////////////////
function ClassItem (sCourseKey, iCredits, sGrade)
{
	this.sCourseKey = sCourseKey;
  if (IsNumeric (iCredits))
	  this.iCredits   = 1*iCredits;
  else // keep invalid numeric value for error checking later
	  this.iCredits   = iCredits;
  if (typeof(sGrade) != "undefined")
    {
    // Grade is "B [3.000]"
    this.sGrade     = sGrade;
    iBracketPos = sGrade.indexOf('[');
    this.sLetterGrade = Trim(sGrade.substring(0,iBracketPos));
    iGradeNumPos = iBracketPos + 1;
    iBracketPos = sGrade.indexOf(']');
    this.sNumericGrade = sGrade.substring(iGradeNumPos,iBracketPos);
    //alert ("Grade: " + this.Grade + "; Letter=" + this.sLetterGrade + "; Number=" + this.sNumericGrade);
    }
}
///////////////////////////////////////////////////////////////////////////////
function AddInprogressClass (sCourseKey, iCredits)
{
if (sCourseKey.length > 0)
	aClassListArray[aClassListArray.length] = new ClassItem (sCourseKey, iCredits);
}
///////////////////////////////////////////////////////////////////////////////
function AddInprogressClass2ndPage (sCourseKey, iCredits, sGrade)
{
if (sCourseKey.length > 0 && iCredits.length > 0)
	aClassListArray[aClassListArray.length] = new ClassItem (sCourseKey, iCredits, sGrade);
}
///////////////////////////////////////////////////////////////////////////////
// DrawClassInput2ndPage
///////////////////////////////////////////////////////////////////////////////
function DrawClassInput2ndPage(sCreditsLit, sForm)
{
for (ClassNum = 1; ClassNum <= aClassListArray.length ; ClassNum++ )
{
rite ("<tr>");
rite ('<td><input type="text" name="CLASS'   + ClassNum + '" value="' + aClassListArray[ClassNum-1].sCourseKey + '" /></td>');
rite ('<td><input type="text" name="NUMCRED' + ClassNum + '" value="' + aClassListArray[ClassNum-1].iCredits   + '" /></td>');
rite ('<td><input type="text" name="GRADE'   + ClassNum + '" value="' + aClassListArray[ClassNum-1].sGrade     + '" /></td>');
rite ("</tr>");
}

}
///////////////////////////////////////////////////////////////////////////////
// DrawClassInput
// Draws the input information for the Term Calculator.  Called from script SD2GPATRM.
// Vital Components:	
//	sCourseCount: tells DrawClassInput how many Classes to list.
//	sGradePicklist: tells DrawClassInput how to populate the picklists it is creating
//	sGradeInput: tells DrawClassInput what type of input to use for Grade: Picklist or Input Box
//	sCreditsLit: tells DrawClassInput what the literal is for CREDITS
///////////////////////////////////////////////////////////////////////////////
function DrawClassInput(sCourseCount, sGradePicklist, sGradeInput, sCreditsLit, sForm)
{
//alert ("DrawClassInput - enter");
 if (sGradeInput == "L") // if the Grade Inputs are supposed to be "L" for Letter Grades
 {
   iNumClasses = aClassListArray.length;
	 if (sGradePicklist.length < 1)
	 {
		 rite('<span class="GPATermResultCellBig">');
		 rite('ERROR <br>');
		 rite('The Grade Information in UCX-STU385 has not been set up.  Please alert the Computer Center.  ');

		 rite('We apologize for the inconvenience. </span>');
	 }
	 else{
	  for (ClassNum = 1; ClassNum <= sCourseCount ; ClassNum++ )
	  {
		rite('<!-- Class ' + ClassNum + ' Begin -->');
		rite('  <tr height="2" width="90%">');
		rite('     <td nowrap align=left class="GPAFormTitle" width="25%" headers="blank1"></td>');
    
    // COURSE KEY
		rite('     <td nowrap align=left class="GPAFormTitle" width="20%" headers="ClassName">');
		rite('     <input class="GPAClassInputText" size="14" maxlength="20" name="FAUXCLASS' + ClassNum + '"');
		if (ClassNum <= iNumClasses && aClassListArray[ClassNum - 1] != undefined)
			rite('      value="' + aClassListArray[ClassNum - 1].sCourseKey + '"');
		else if (sForm.NEXTFORM.value == "1STTIME")
			rite('      value="Class ' + ClassNum + '"');
    else // no class in this slot - leave it blank      
			rite('      value=""');
		rite('      onfocus="ClearField(sForm.CLASS' + ClassNum + ');"');
		rite('onKeyPress="checkEnter(event, \'TERM\', sForm, sCreditsLit, sCourseCount, sGradePicklist, iRounding);">');
		rite('	 </td>');
  
  // CREDITS
		rite('     <td align=left width="15%" headers="Credits">');
		rite('<input class="GPAClassInputText" size="3" maxlength="5"');
		rite(' name="NUMCRED' + ClassNum + '" id="NUMCRED' + ClassNum + '" ');
		if (ClassNum <= iNumClasses && aClassListArray[ClassNum - 1] != undefined)
			rite(' value="' + aClassListArray[ClassNum - 1].iCredits + '"');
		else // leave credits blank
			rite(' value=""');
		rite('onKeyPress="checkEnter(event, \'TERM\', sForm, sCreditsLit, sCourseCount, sGradePicklist, iRounding);"');
		rite('    </td>');
		
    // GRADES - letter grades from STU385
		if (sGradeInput == "L") // If the input type is Picklist ("L" for Letter Grades)
		{
		rite('    <td align=left width="15%" headers="Grade">');
		rite('         <select name="GRADE' + ClassNum + '" id="GRADE' + ClassNum + '" size="1" ');
		rite('            nowrap accesskey="s" style="font-family:Courier;"');
		rite('onKeyPress="checkEnter(event, \'TERM\', sForm, sCreditsLit, sCourseCount, sGradePicklist, iRounding);">');

    // Note: it says "credits" below but it really means "grade-number"
		for (x = 0; x < sGradePicklist.length ; x++ )
			{
			sGradeOption = '<option value="' + sGradePicklist[x].grade + '['+ sGradePicklist[x].credits + ']" ';
      // If this is the grade on the course (exists when the 1st page is redisplayed) then select this option
      if (ClassNum <= iNumClasses && aClassListArray[ClassNum - 1].sGrade == sGradePicklist[x].grade)
        sGradeOption = sGradeOption + ' selected ';
			if (sGradePicklist[x].grade.length > 1) // has plus or minus; don't need the extra space
        sDisplayGrade =  sGradePicklist[x].grade;
      else // Grade is only 1 char - add a space
        sDisplayGrade =  sGradePicklist[x].grade + " ";
      sGradeOption = sGradeOption + '"> ' + sDisplayGrade + '[' + sGradePicklist[x].credits + ']</option>';
      rite (sGradeOption);
			}
		}
    // GRADES - numeric grades - STU385 is not used
    // NOTE: at the top of this function we check for GradeInput=L so this code will never be TRUE - it is dead code
		else if (sGradeInput == "N") // If the input type is Input Box ("N" for Numeric Grades)
		{
		rite('    <td align=right width="15%" headers="Grade">');
		rite('<input class="GPAClassInputText" type="text" size="3" maxlength="4"');
		rite(' name="GRADE' + ClassNum + '" id="GRADE' + ClassNum + '" value=""');
		rite('onKeyPress="checkEnter(event, \'TERM\', sForm, sCreditsLit, sCourseCount, sGradePicklist, iRounding);"');

		rite('>');
		}
		//  END display Grades as input boxes 
		rite('    </td>');
		rite('    <td align=left width="25%" headers="blank2">');
		rite('    </td>');
		rite('  </tr>');
		rite('<!-- Course ' + ClassNum + ' End -->');
	
	}
 }
 }
}
///////////////////////////////////////////////////////////////////////////////
// OpenNewWindow
// Opens a new window for Graduation Calculator (Credits Required Link)
///////////////////////////////////////////////////////////////////////////////
function OpenNewWindow(OpenPage)
{
	sWindowParams = "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes";
	open(OpenPage, "DegreeInformation", sWindowParams);
}
///////////////////////////////////////////////////////////////////////////////
// CLEARFIELD
// Clears out the Class field IFF the value of the text field does not start with "Class"
///////////////////////////////////////////////////////////////////////////////
function ClearField(field)
{
	ClassSub = field.value.substring(0,5);
	if (ClassSub == "Class")
	field.value="";
}
///////////////////////////////////////////////////////////////////////////////
// CHECKENTER
// This function is invoked every time a key is struck (onKeyPress).  
// It checks whether the key struck was "Enter".  If so, it'll submit the Calculate function.
///////////////////////////////////////////////////////////////////////////////
function checkEnter(e, CalcType, sForm, sCreditsLit, sCourseCount, sGradePicklist, iRounding, iRoundOrTruncate)
{ //e is event object passed from function invocation

	var characterCode //literal character code will be stored in this variable
	//if "which" property of event object is supported (NN4)
	if(e && e.which)
	{ 
		e = e
		characterCode = e.which //character code is contained in NN4's which property
	}
	else
	{
		e = event
		characterCode = e.keyCode //character code is contained in IE's keyCode property
	}
	//if generated character code is equal to ascii 13 (if enter key)
	if(characterCode == 13){ 
		if (CalcType=="GRAD")
			CalculateGPA(sForm, sCreditsLit, iRounding, iRoundOrTruncate);

		if (CalcType=="TERM")
			CalculateTermGPA(sForm, sCourseCount, sCreditsLit, sGradePicklist, iRounding, iRoundOrTruncate);

		if (CalcType=="ADV")
			CalculateAdviceGPA(sForm, sGradePicklist, sCreditsLit, iRounding, iRoundOrTruncate);

		return false
	}
	else{
	return true
	}
}
