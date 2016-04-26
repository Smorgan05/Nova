<h1 style"font-size:200%;">Nova</h1>

<img src="https://i.imgur.com/1mPjoac.png">

<h2 style"font-size:200%;">Goal</h2>

<p>The main goal of the Nova Pack is to create a flexible OEM pack that can be used on multiple Windows Operating Systems. This means we want to be able to use this on legacy systems that have powershell 2.0 and above (think Vista and above). That being said we can modify an ISO and inject this into the Windows install media sources folder to automate the creation of a custom distro of windows. This is easier to do than Sysprepping an image or modifying the WIM (Windows Install Image). Also given the ability to use this on multiple Windows Operating Systems we can make one OEM pack to conquer all of them. That means we don't need to do multiple syspreps of the same install across different versions of windows. We can also interface different scripting languages to the OS making it easier to customize the OS when it's installed.</p>

<h2 style"font-size:200%;">Creation of Custom Distribution</h2>

<ul>
<li>Grab a ISO editor (ie PowerISO)</li>
<li>Download the Nova Pack Release Repository</li>
<li>Open a Windows ISO (vista or newer)</li>
<li>Navigate to the sources folder</li>
<li>Drag the $OEM$ Folder from Nova Pack onto the Image</li>
<li>You now have a custom Distribution of Windows</li>
</ul>

<p>This is what you should see after your finished:</p>

<img src="https://i.imgur.com/NUjJLDO.jpg">

<p>**Note for Vmware Install it is recommended that you do so without automation. If you have an automated Install the post install will kill Vmware Tools when it starts to install. You will have to reinstall Vmware Tools afterwards. When you do this select the repair option. This is to prevent the starter from running multiple times.</p>

<h2 style"font-size:200%;">Custom Distro of Windows</h2>

<p>A custom distro of windows means we are packing software, tweaks, themes, etc. This makes it possible to customize windows at the same level as a sysprep but save time by saying what OS we want to do things to by using the WMI (Windows Management Instrumentation). Additionally we can use python or another programming language to use in parallel with Windows Powershell.</p>

<h2 style"font-size:200%;">Live Install</h2>
<p>Another feature included in the OEM Pack is the ability to do a live install on an Operating system already installed.  This means you run the Live script included in scripts folder.  You do not need to place that folder inside the Setup Folder inside the Windows folder.  This live script will set the path location automatically in order to run.  Additionally This will work on Windows XP with limited functionality in terms of Setup Updater.  To be more precise in order to work on Windows XP you must have Powershell 2.0 installed.</p>

<h2 style"font-size:200%;">Nature of OEM Pack</h2>

<ul>
<li>Live Install - We can run this on system that already has a Windows OS Installed.</li>
<li>Offline / Online Capability - The ability to update setup files on the fly with an internet speed fast enough.  While being able to do do a full online configuration (with Windows 7 or newer) and downloading all the setups if need be. </li>
<li>Multilingual - The ability to interface powershell to other scripting languages by using a multilingual controller (Starter.ps1)</li>
<li>Modular - By having multiple script controllers we can easily add modules to the pack (Setup.ps1, Starter.ps1, setupComplete.cmd)</li>
<li>Universal - Given the large amount of Windows Operating Systems supported it is easy to switch Versions or support a large swath of operating systems if necessary</li>
</ul>

<h2 style"font-size:200%;">Additional thoughts on a Smart OEM Pack</h2>

<p>There are certain advantages when using powershell. The first being access to the WMI which makes it possible to integrate smart scripting into the OEM pack. This makes it possible to look for specific versions of windows and tell the pack "Ok only do this for this version, edition, or hardware".</p>

<h2 style"font-size:200%;">Support</h2>

<ul>
<li>Windows Vista - Windows 10</li>
<li>Windows Server 2008 - Windows Server 2016</li>
<li>Windows Embedded 7 - Windows Embedded 10</li>
</ul>

<h2 style"font-size:200%;">A Small Thank you</h2>

<p>Thank you to all the projects that came before.  Thank you oem projects that used batch coding so that a structure could be made form nothing.  Those guys who came up with suggestions and made this project possible.  The code I was allowed to convert and piece together to make a very tightly coded project.  And those simple moments of zin that allowed for this to come to fruition.  Three years and we finally have the best of the best. </p>

<h2 style"font-size:200%;">Nova License Agreement</h2>

<p>For the purposes of the coding of the Nova (Original Equipment Manufacturer or OEM) Pack all coding is covered under the GNU General Public License v3 (GNU GPL v3). To be more precise this coding is given free as it is without any warranty. Additionally the license is granted to all users with the only caveat being that it not be used in a Business like environment. This permission must be granted to those who wish to use it in such an environment as not doing so is in violation of the Nova License. In using this software you agree that it is given AS-IS meaning that you take full responsibility for for the damage which may occur with the use of this pack or coding. The only exclusion to the Nova License is the External Scripts directory (ExtRun) which is protected by those respected author or authors of that code.</p>

<p>Use of Python or any other programming languages on Nova is given to those respected License holders. This means that you agree with the respective license holder on using their programming language.  Additionally, Nova Pack makes use of 3rd party software not integrated into Windows by default.  This software entails agreement of their respective EULAs or license agreements use of this pack represents acceptance of all those included.  Lastly use of Microsoft Windows with Nova is necessary for Nova to function properly as whole. That being said Windows is a property of Microsoft with permission being given between the user and Microsoft.</p>

<readme created by Skaendo />
