﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
FileEncoding, UTF-8

nqs := []

props_index = 1
Loop, read, questions.txt
{
	if A_Index = 1
		skip := A_LoopReadLine
	else if A_Index = 2	
		props := StrSplit(A_LoopReadLine, "|")
	Else if(StrLen(A_LoopReadLine) > 0 )
	{
		property := props[props_index]		
		if props_index = 1
		{
			newQ := {(property):A_loopReadLine}
			nqs.Push(newQ)
			props_index := props_index + 1			
		}
		else if(props_index < props.MaxIndex())
		{
			newQ[property] := A_LoopReadLine
			props_index := props_index + 1
		}
		Else
		{
			newQ[property] := A_LoopReadLine
			props_index = 1
		}		
	}	
}
MsgBox, , Begin questions, % "Number of quesions: " . nqs.MaxIndex()
Loop % nqs.MaxIndex()
{
	question := nqs[A_Index]
	NQ := question.nq
	Q := question.q
	A := question.a
	if NQ not in %skip% 
		Gosub, ValidateQ
}
return

ValidateQ:
InputBox, RQ, %NQ%, %Q% 
	if (ErrorLevel != 1) ;not cancel
	{
		if(RQ=A)
			MsgBox, , %NQ%, Correcto, 2
		Else
			{
				errorDetail := "Bad: " . RQ . "`r`n" . "Correct: " . A
				MsgBox, , %NQ%, %errorDetail%
				Gosub, ValidateQ
			}
	}
return