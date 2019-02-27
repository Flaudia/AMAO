#!/usr/bin/env python
# coding: utf-8
import os
from os.path import isfile, join, dirname, exists, realpath, normpath, isdir

local_path = dirname(realpath(__file__))

typologies = ["MCU","MCUA","noG"] 

def solution_name_generator(solution_name):
	solution_name = solution_name.replace(".","_plan.")
	return solution_name



for k in range(0, len(typologies)):

	rootdir = local_path + '/problems/improved/' + typologies[k] 

	for subdir, dirs, files in os.walk(rootdir):	
	
		folder_name = (subdir.split("/"))
		
		if len(folder_name) > 8:

			folder_name = folder_name[-1]

			encoding_path = local_path + "/encodings/improved/"+typologies[k]+"/baxter.pddl"
	
			solutions_directory_path = local_path + "/solutions/UPM/"+typologies[k]+"/"+folder_name

			times_directory_path = local_path + "/times/UPM/"+typologies[k]+"/"+folder_name

			if not os.path.exists(solutions_directory_path):
				os.makedirs(solutions_directory_path)

			if not os.path.exists(times_directory_path):
				os.makedirs(times_directory_path)


			for file in files:

				solution_name = solution_name_generator(os.path.basename(file))

				times_path = times_directory_path +"/time_" + solution_name +".txt"

				problem_path = rootdir + "/" + folder_name + "/" + str(file)


				print "\n\n------------------------------------------------------------------FIRST STEP----------------------------------------------------------------------------------------\n\n"

				command = "./pyrunlim.py 2> " + times_path + " -t3600 ./UPMurphi/bin/upmc " +  encoding_path + " " + problem_path + " --custom 1 6 5"
				os.system(command)

				print "\n\n------------------------------------------------------------------SECOND STEP----------------------------------------------------------------------------------------\n\n"

				command =  "./encodings/improved/" + typologies[k] + "/baxter_planner" 
				os.system(command)

				print "\n\n------------------------------------------------------------------THIRD STEP----------------------------------------------------------------------------------------\n\n"

				command = "mv " + rootdir + "/" + folder_name + "/" + solution_name + " " + local_path + "/solutions/UPM/" + typologies[k] + "/" + folder_name
				os.system(command)

				command = "rm " + local_path + "/encodings/improved/" + typologies[k] + "/baxter.cpp"
				os.system(command)

				command = "rm " + local_path + "/encodings/improved/" + typologies[k] + "/baxter.goals" 
				os.system(command)

				command = "rm " + local_path + "/encodings/improved/" + typologies[k] + "/baxter_planner"
				os.system(command)

				command = "rm " + local_path + "/encodings/improved/" + typologies[k] + "/baxter.errors"
				os.system(command)

				command = "rm " + local_path + "/encodings/improved/" + typologies[k] + "/baxter.properties"
				os.system(command)

				command = "rm " + local_path + "/encodings/improved/" + typologies[k] + "/baxter.h"
				os.system(command)

				command = "rm " + local_path + "/encodings/improved/" + typologies[k] + "/baxter.m"
				os.system(command)

				command = "rm " + local_path + "/encodings/improved/" + typologies[k] + "/baxter.startstates"
				os.system(command)

				command = "rm " + local_path + "/encodings/improved/" + typologies[k] + "/baxter.transitions"
				os.system(command)
	
