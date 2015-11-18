<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>TUT ATI - remote elevator lab</title>
    <link media='screen and (min-width: 1850px)' href="css/wide.css" rel="stylesheet" type="text/css">
    <link media='screen and (max-width: 1849px)' href="css/narrow.css" rel="stylesheet" type="text/css"> 
    <link href="css/ttu_theme.css" rel="stylesheet" type="text/css">   
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script> 

</head>
<body onload="check_cookies()">
	<script>
        var msgbox;
        function check_cookies() {
            msgbox = document.getElementById("messagebox");

            if (navigator.cookieEnabled == false) {
                window.alert( "Cookies are not enabled.");
            }

            var upload_result = getCookie("upload_result");

            if (upload_result == "1") {
                err_msg = getCookie("err_message");
                msgbox.className = "error";
                err_msg = err_msg.replace(/\+/g, " ");
                msgbox.innerHTML = err_msg;
            } else if (upload_result == "0") {
                msgbox.className = "success";
                msgbox.innerHTML = "Upload successful. <br> Programming FPGA...";

                // load the new bitfile
                load();
            }
            if (upload_result == "1" || upload_result == "0") {
                msgbox.style.display = "block";
            }
        }

        function getCookie(cname) {
            var name = cname + "=";
            var ca = document.cookie.split(';');
            for(var i=0; i<ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0)==' ') c = c.substring(1);
                if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
            }
            return "";
        }

		function show_file() {
			input = document.getElementById("uploadFile");
			selectedFile = document.getElementById("selectedFile");
			selectedFile.innerHTML = input.files[0].name;
		}

		function browse() {
			$("#uploadFile").click();
		}

		function move(floor) {
		    $.get("cgi-bin/move.cgi?f="+floor, function(data) {   
                msgbox.className = "info";
                msgbox.innerHTML = "Signal sent to elevator.";
                msgbox.style.display = "block";
            });
		}

        // function showMessage()
		function load() {           
            msgbox.className = "info";
            msgbox.innerHTML = "Programming FPGA...";
            msgbox.style.display = "block";
		    $.get("cgi-bin/load.cgi", function(data) {   
                if (data != undefined) {
                    msgbox.className = "success";
                    msgbox.innerHTML = "Success: Bitstream downloaded into XuLA-200 !";
                }
            });

		}

		function wrapper() {           
            msgbox.className = "info";
            msgbox.innerHTML = "Programming wrapper FPGA...";
            msgbox.style.display = "block";
		    $.get("cgi-bin/wrapper.cgi", function(data) {  
                if(data.substring(0,7) == "Success") { 
                    msgbox.className = "success";
                } else {
                    msgbox.className = "error";
                }
                if (data != undefined) {
                    msgbox.innerHTML = data;
                }
            });

		}

		function load_demo() {           
            msgbox.className = "info";
            msgbox.innerHTML = "Programming FPGA...";
            msgbox.style.display = "block";
		    $.get("cgi-bin/load_demo.cgi", function(data) {   
                if (data != undefined) {
                    msgbox.className = "success";
                    msgbox.innerHTML = "Success: Bitstream downloaded into XuLA-200 !";
                }
            });
		}
	</script>

	<div id="main">
    	<div id="header">
        	<h1 class="title">TUT ATI: remote elevator lab</h1><br>

        </div>
        <div id="body">
        	<div id="left_pane">
                <div class="textbox">
                	<h2>Introduction</h2>
                    <p> In this remote lab you can upload your bit-file to program the FPGA and test your program remotely. </p>
                    <h2>Steps</h2>
                    <ol class="steps">
						<li>
                        	Program the safety wrapper 
                            <button class="btn" onclick="wrapper()">Program Wrapper</button>
                        </li>
                        <li>
                        	Try the demo code.
                            <button class="btn" onclick="load_demo()">Program Demo</button>                                
                        </li>
                        <li>
                        	Upload Bit-File.
                            <div id="upload">
                                <form enctype="multipart/form-data" action="upload.php" method="POST">
                                    <input id="uploadFile" name="userfile" type="file" style="display:none" onchange="show_file();"/>
                                    <div class="btn1" id="uploadTrigger" onclick="browse()">Browse...</div>
                                    <input class="btn2" type="submit" value="Upload" />
                                </form>
                                <div id="readyFiles">Selected file: <span id="selectedFile">None</span></div>
                            </div>
                        </li>
                        <li>
                        	Try it out.
                    	</li>
                    </ol>
           		</div>
                <div id="messagebox" class="success">
                </div>
            </div>
        	<div id="middle_pane">
                <div id="control">
                    <div class="buttons">
                    	<div class="lift_text">Outer Buttons</div>
                        <a href="#" id="btn_4" class="ebtn" onclick="move(4)"></a>
                        <a href="#" id="btn_3" class="ebtn" onclick="move(3)"></a>
                        <a href="#" id="btn_2" class="ebtn" onclick="move(2)"></a>
                        <a href="#" id="btn_1" class="ebtn" onclick="move(1)"></a>
					</div>
                    <div class="buttons">
                        <div class="lift_text">Inner Buttons</div>
                        <button id="btn_4" class="ebtn" onclick="move(9)"></button>
                        <button id="btn_3" class="ebtn" onclick="move(8)"></button>
                        <button id="btn_2" class="ebtn" onclick="move(7)"></button>
                        <button id="btn_1" class="ebtn" onclick="move(6)"></button>
                    </div>
                	<div class="clear"></div>
                </div>
            </div>
            <div id="right_pane">	
            	<div id="webcam">
                	<!--<img id="camera" src="http://<?php echo split(":", $_SERVER['HTTP_HOST'])[0]?>:10011/mjpg/video.mjpg"/>-->
                	<img id="camera" src="http://<?php echo split(":", $_SERVER['HTTP_HOST'])[0]?>:10011/nphMotionJpeg?Resolution=640x480&Quality=Standard"/>
                </div>
            </div>
            <div class="clear"></div>
        </div>
    </div>
    <div id="footer"> 
        <div id="contact">
            <span>Contact e-mail: siavoosh@ati.ttu.ee; hkinks@ati.ttu.ee</span>
            <a href="http://mini.pld.ttu.ee/~lrv/IAY0340.old/">Course homepage</a>
        </div>
        <div id="logos">
            <img src="img/logos/ttulogo.png" height="64"/>
            <img src="img/logos/atilogo.png" height="64"/>
            <img src="img/logos/raklogo.gif" height="64"/>
        </div>
    </div>
</body>
</html>
