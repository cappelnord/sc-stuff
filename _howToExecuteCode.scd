/*
You will probably see this on the left side of your window. On your right side you will either
see a white page titled "Documentation home" or some more cryptic messages, where it says
"Post window" very small. Post window is what we want right now, SuperCollider will talk
to you there!

If you don't see the post window you can switch from Help browser to Post window or make
sure that it is active (Menu: View -> Docklet -> Post window)
*/

// Above is a comment. This is a comment too! You can recognize it by its colors.
// It is not code that is meant to be executed, just to comment on things.

// This is code:
4 + 4;

// If we want to execute a line of code we put our text cursor into the line of
// code and press Ctrl + Return (Windows, Linux) or Cmd + Return (Mac)

10 * 10;

// SuperCollider will tell you the result of this operation in the post window.

// Sometimes we want to execute more than one line of code. This is then put
// together in a region surrounded by brackets. Put the text cursor inside of
// the bracket and press Ctrl + Return or Cmd + Return.

(
var a = 20;
var b = 10;
a - b;
)

// In order to hear something we must boot our "server". This can be either done
// with code or with Ctrl + B / Cmd + B.

s.boot;

// After booting the server we hopefully see some happy message in the postwindow
// like: "SuperCollider 3 server ready." or "Shared memory server interface initialized".

// This will make a short sound:
().play;

// To also see the sound I recommend to activate the scope:
s.scope;

// The most important shortcut in SuperCollider is to stop any sound at any time.
// It is very important to remember this shortcut! Sometimes while experimenting
// you might create a very loud sound by accident and want it to stop.
// Be very careful with your ears!!!

// To stop any sound/process: Ctrl + . / Cmd + .

// This sound will not stop by itself unless you used the shortcut above:
{SinOsc.ar(440).dup * 0.1}.play;


// For an introduction into SuperCollider I recommend starting with the Help
// browsers built in "Getting Started with SuperCollider".
// Another awesome resource are the YouTube Tutorials by Eli Fieldsteel.

// https://www.youtube.com/watch?v=yRzsOOiJ_p4&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC