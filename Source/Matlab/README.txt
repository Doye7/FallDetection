Open MATLAB and point to the source files contained in the MATLAB folder.

------ Files -------

Setup - Contains the code to initialise the webcam for use
	with the rest of the program.

GetAverage - A simple function that generates the average
	after capturing 5 sucessive images.

GetInfo - Builds and manages the GUI for inputting email
	details. Calls the Authentication function in Java

Loop2 - The main loop of the program, handles the primary bulk of
	the image processing and calls the SendMail function in Java.

Quickstart - The file executed to launch the program from scratch.
	If compiled, set this as the main file.

GoogleMailSend.jar - Contains the java functions for use by MATLAB, handles
	communication with Googles Servers.

------- Notes --------

Webcam used for testing: Logitech G525
Systems used for testing - Windows 10, 2 seperate devices



	


