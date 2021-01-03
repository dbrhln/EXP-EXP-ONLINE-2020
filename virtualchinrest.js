/* Plugin description
        Virtual chinrest JS plugin by Deborah J Lin and Alan A Weiss (2020)
        Based on Li, Q.; Joo, S.J.; Yeatman, J.D., & Reinecke, K. (2020) Virtual Chinrest
        Works in conjunction with jspsych-resize-noscale.js (edited resize jspsych module)
*/

jsPsych.plugins["virtualchinrest"] = (function(){

    var plugin = {};
    //----------------------------------------------------------------------
    //Plugin info
    plugin.info = {
      name: 'virtualchinrest',
      parameters: {
        stimulus: {
            type: jsPsych.plugins.parameterType.HTML_STRING,
            pretty_name: 'Stimulus',
            default: undefined,
            description: 'The HTML string to be displayed'
          }
      }
    }
    //----------------------------------------------------------------------
    plugin.trial = function(display_element, trial) {
      //HTML text
      display_element.innerHTML = trial.stimulus +
                                    "<style> mybutton {text-align: center;}</style>" + '<p><button id="mybutton" class="jspsych-btn">'+ "Start."+'</button></p>' ;

      document.getElementById("mybutton").addEventListener("click", animateCircleMotion) ;

      //--------Set up Canvas begin-------
      var circleColor = "#FFFFFF" ; //white
      var squareColor = "#A0522D" ; //brown
      var backgroundColor = "#808080" ;

      //Create a canvas element and append it to the DOM
      var canvas = document.createElement("canvas");
      display_element.appendChild(canvas);

      //The document body IS 'display_element' (i.e. <body class="jspsych-display-element"> .... </body> )
      var body = document.getElementsByClassName("jspsych-display-element")[0];

      //Save the current settings to be restored later
      var originalMargin = body.style.margin;
      var originalPadding = body.style.padding;
      var originalBackgroundColor = body.style.backgroundColor;

      //Remove the margins and paddings of the display_element
      body.style.margin = 0;
      body.style.padding = 0;
      body.style.backgroundColor = backgroundColor; //Match the background of the display element to the background color of the canvas so that the removal of the canvas at the end of the trial is not noticed

      //Remove the margins and padding of the canvas
      canvas.style.margin = 0;
      canvas.style.padding = 0;

      //Get the context of the canvas so that it can be painted on.
      var ctx = canvas.getContext("2d");

      //Declare variables for width and height, and also set the canvas width and height to the window width and height
      var canvasWidth = canvas.width = window.innerWidth*0.95 ;
      var canvasHeight = canvas.height = window.innerHeight*0.25 ;

      //Set the canvas background color
      canvas.style.backgroundColor = backgroundColor;

      //--------Set up Canvas end-------
      //Params
      var dotRadius = 10 ;

      var circleOrigin = {
        x: canvasWidth/2+65, //x coordinate
        y: canvasHeight/2 //y coordinate
      }

      //Circle starting point and direction
      var circle = {
        x: circleOrigin.x, //x coordinate
        y: circleOrigin.y, //y coordinate
        vx: -1 //x jumpsize (if any)
      };

      //Fixation square
      var squareLength = 25 ;

      var square = {
        dx: squareLength, //radius of square
        x: canvasWidth*0.75+squareLength,
        y: canvasHeight/2 - squareLength/2
      }

      var stopDotMotion = false ;

    //Function to start the keyboard listener
    function startKeyboardListener(){
        //Create the keyboard listener to listen for subjects' key response
        keyboardListener = jsPsych.pluginAPI.getKeyboardResponse({
          callback_function: after_response,
          valid_responses: ['space'], //The keys that will be considered a valid response and cause the callback function to be called
          persist: false, //If set to false, keyboard listener will only trigger the first time a valid key is pressed. If set to true, it has to be explicitly cancelled by the cancelKeyboardResponse plugin API.
          allow_held_key: false //Only register the key once, after this getKeyboardResponse function is called. (Check JsPsych docs for better info under 'jsPsych.pluginAPI.getKeyboardResponse').
        });
    }

    function end_trial() {
			//Stop the dot motion animation
      stopDotMotion = true;
      jsPsych.pluginAPI.cancelKeyboardResponse(keyboardListener);

      var ball_dist = (square.x + squareLength*0.5 - circle.x) ;
      //document.getElementById("mydist").innerHTML = "<div>Your viewing distance is " + Math.round(100*ball_dist)/1000 + "cm.</div>" ;

      var trial_data = {
        "ball_dist": ball_dist
      } ;

      display_element.innerHTML='';

			//Restore the settings to JsPsych defaults
			body.style.margin = originalMargin ;
			body.style.padding = originalPadding ;
			body.style.backgroundColor = originalBackgroundColor ;

      jsPsych.finishTrial(trial_data) ;

    }

		function after_response() {
      end_trial();
		}

    //Begins animation
    drawSquare() ;
    drawCircle() ;

    function drawSquare(){
      //Draw square
      ctx.beginPath() ;
      ctx.fillStyle = squareColor ;
      ctx.fillRect(square.x,square.y,square.dx,square.dx) ;
      ctx.stroke() ;
    }

    function updateAndDraw(){
      clearCircle() ;
      updateCircle() ;
      drawCircle() ;
    }

    function clearCircle(){
      ctx.beginPath();
      ctx.arc(circle.x, circle.y, dotRadius+2, 0, Math.PI * 2);
      ctx.fillStyle = backgroundColor;
      ctx.fill();
    }

    function drawCircle(){
      ctx.beginPath();
      ctx.arc(circle.x, circle.y, dotRadius, 0, Math.PI * 2);
      ctx.fillStyle = circleColor;
      ctx.fill();
    }

    function updateCircle(){
      circle.x += circle.vx ;

      if (circle.x <= 0) {
        resetLocation(circle) ;
      }
    }

    function resetLocation(circle) {
      circle.x = circleOrigin.x ;
    }


    function animateCircleMotion() {
      //Stop click button listener and transition to task
      //document.getElementById("mybutton").innerHTML = "Press space to stop.</p>" ;
      document.getElementById("mybutton").removeEventListener("click", animateCircleMotion);

			//frameRequestID saves a long integer that is the ID of this frame request. The ID is then used to terminate the request below.
      var frameRequestID = window.requestAnimationFrame(animate);

      startKeyboardListener();

			function animate() {
				//If stopping condition has been reached, then stop the animation
				if (stopDotMotion) {
          window.cancelAnimationFrame(frameRequestID); //Cancels the frame request
				}
				//Else continue with another frame request
				else {
					frameRequestID = window.requestAnimationFrame(animate); //Calls for another frame request

          updateAndDraw(); //Update and draw each of the dots in their respective apertures
				}
			}
    }

    };

    return plugin ;

})();
