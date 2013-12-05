if (redstone.testBundledInput("bottom", 2)) then
	shell.run("glasslite")
elseif (redstone.testBundledInput("bottom", 4)) then
	shell.run("glass3.0")
else
	shell.run("tickmonitorstartup")
end