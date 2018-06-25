% Create a figure
imFig = figure('Position', [800,500,250,250]);
set(imFig, 'MenuBar', 'none');
set(imFig, 'ToolBar', 'none');

% Set default values (Testing purposes)

emailSource = "removed";
emailPassword = "removed";
emailDestination = "removed";
verification = false;

% Create a simple UI with input text and confirmation buttons

txtSource = uicontrol('Style','text',...
        'Position',[30,200,70,20], 'String','Email: ');
    
 txtPassword = uicontrol('Style','text',...
         'Position',[20,150,70,20], 'String','Password: ');
     
 txtDestination = uicontrol('Style','text',...
         'Position',[20,100,70,20], 'String','Destination: ');
     
 editSource = uicontrol('Style','edit',...
        'Position',[105,203,120,20]); 
    
 editPassword = uicontrol('Style','edit',...
        'Position',[105,153,120,20],'FontName', 'Webdings');
    
 editDestination = uicontrol('Style','edit',...
        'Position',[105,103,120,20]);
    
 txtVerify = uicontrol('Style','text','Visible','off',...
        'Position',[30,35,200,60], 'String','Username Password combination not recognised');
% confirmCallback is the code that will execute when the button is clicked
    
confirmCallback = "emailSource = editSource.String;"...
    + "emailPassword = editPassword.String;"...
    + "emailDestination = editDestination.String; uiresume;";
    
btnConfirm = uicontrol('Style', 'pushbutton', 'String', 'Confirm',...
    'Position', [20,20,70,20], 'Callback', char(confirmCallback));

%btnDefault = uicontrol('Style', 'pushbutton', 'String', 'Default',...
%   'Position', [160,20,70,20], 'Callback', 'uiresume;');
% Wait until one of the UI buttons is clicked then verify password
% If correct password close dialogue
while not(verification)
uiwait;
try
verification = javaCode.Authentication(emailSource, emailPassword);
catch exception
end
emailSource = "removed";
emailPassword = "removed";
emailDestination = "removed";
txtVerify.Visible = 'on';
end
close all;

