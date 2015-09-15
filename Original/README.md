<h3>Introduction</h3>

<p>This will be a multi-day project, so don&#39;t worry if you don&#39;t get it all done today. There will be an opportunity to continue to work on it tomorrow. However, it is very important, as there are a number of key concepts in this exercise.</p>

<p>You will build a ruby command line application to help users manage their contacts through a Request-Response CLI interface. </p>

<p>This means that you will be issuing commands like:</p>

<pre><code>ruby contact_list.rb show 1
</code></pre>

<p>This would breakdown according to the following:</p>

<ul>
<li><code>ruby</code> - Obviously, the ruby parser, same as you would use to run any Ruby script.</li>
<li><code>contact_list.rb</code> - The name of your script.</li>
<li><code>show</code> - The command you are going to issue to the Contact list app. (Full list of commands below)</li>
<li><code>1</code> - The parameter being passed to that command. (Tip: Not all commands will take parameters. Some will take multiple.)</li>
</ul>

<p><strong>Repository:</strong> Create a repository for this project (instead of working within the gist).</p>

<p><strong>Reminders &amp; Tips:</strong>  </p>

<ul>
<li>Commit and push your progress on a regular basis</li>
<li>Seed some fake data in so you don’t have to create contacts each time you restart the app</li>
</ul>

<h3>Setup</h3>

<p>The project will be written in an Object Oriented way. Each contact will be represented by an instance of the <code>Contact</code> object. Similarly, the main application (responsible for user input and output) could be managed via an instance of <code>Application</code>.</p>

<p>Use the code provided. However, <strong>instead of cloning this gist, simply copy/paste the code from it into your own brand new git repository</strong> (create a folder and <code>git init</code> inside it), keeping the file names consistent of course.</p>

<h3>Bundler</h3>

<p>This project uses Bundler, a very popular ruby library (gem) that helps us manage gem dependencies at the project level. The <code>Gemfile</code> is actually a <em>ruby</em> file which lists which gems this projects needs to use. Bundler then manages the versions etc for us based on this file. Simply run <code>bundle install</code> to install the necessary gems for a given project.</p>

<p>Bundler is already installed on your vagrant machine, but running <code>gem install bundler</code> to install the latest version shouldn&#39;t cause any issues.</p>

<p><strong>More on Bundler:</strong></p>

<ul>
<li><a href="http://ruby.about.com/od/bundler/ss/What-Is-Bundler.htm" target="_blank">http://ruby.about.com/od/bundler/ss/What-Is-Bundler.htm</a></li>
<li><a href="http://yehudakatz.com/2010/09/30/bundler-as-simple-as-what-you-did-before/" target="_blank">http://yehudakatz.com/2010/09/30/bundler-as-simple-as-what-you-did-before/</a></li>
</ul>

<h3>Command Line Arguments</h3>

<p>Arguments to a command can be accessed via the Argument Vector (<code>ARGV</code>, which is a constant because it starts with a capital letter). </p>

<p>Read about it here: <a href="http://stackoverflow.com/questions/13329132/whats-the-point-of-argv-in-ruby" target="_blank">http://stackoverflow.com/questions/13329132/whats-the-point-of-argv-in-ruby</a></p>

<h3>Saving Data</h3>

<p>In order for this app to work, you will need to save your data in a CSV (Comma-Separated Value) file. This is a very standard file format that is ideal for a Contact List app. To learn more about CSV files and the Ruby library for dealing with them, please read the following link:</p>

<p><a href="http://www.sitepoint.com/guide-ruby-csv-library-part/" target="_blank">http://www.sitepoint.com/guide-ruby-csv-library-part/</a></p>

<p>Here is another resource: <a href="http://ruby-doc.org/stdlib-2.0.0/libdoc/csv/rdoc/CSV.html" target="_blank">CSV file</a></p>

<p>Make a new file (<code>touch contacts.csv</code>) that will hold all of your data. When the app starts, it will look for this file. If the file is there, it should load all the contacts from it into memory. In order to do this in an OOP way, you should introduce a <code>ContactDatabase</code> class that is responsible for reading and writing this file. </p>

<p><em>Things to consider:</em> How many methods will this class have? Should they be instance or class methods? At what point(s) should the app write to the file?</p>

<p><strong>Optional:</strong> &quot;Seed&quot; the csv file with some sample data so that you can start off working with existing contacts.</p>

<h3>Task Breakdown</h3>

<p><em>Reminder</em>: This is not a REPL app. There should be no looping; when commands are issued the program terminates after completing that one task.</p>

<h4>Task 1: Main menu and user input</h4>

<p>When the app receives the <code>help</code> command, it should display a menu with options. </p>

<p><strong>The menu:</strong></p>

<pre><code>Here is a list of available commands:
    new  - Create a new contact
    list - List all contacts
    show - Show a contact
    find - Find a contact
</code></pre>

<h4>Task 2: Implement contact creation (<code>new</code> command)</h4>

<p>If the user issues the <code>new</code> command, the command line app should further prompt the user for information about the contact they wish to create. Eg: take a full name and email (separately). These should be added to an (initially empty) array of contacts. The full name and the email should be input as separate strings as they will need to be output as such.</p>

<p>Once a user has entered the data, the app should store the contact into the CSV file and return the ID of the new contact. </p>

<p><strong>Question:</strong> Before implementing, think about whether or not you need to store an ID for each contact in the file (db). Which approach is better and what are the pros and cons? Discuss this with your peers and TAs.</p>

<h4>Task 3: Implement Contact index (<code>list</code> command)</h4>

<p>When the user enters the <code>list</code> command, the app should display a list of all contacts within the app, printed one on each line. Example output:</p>

<pre><code>12: Khurram Virani (kvirani@lighthouselabs.ca)
14: Don Burks (don@lighthouselabs.ca)
---
2 records total
</code></pre>

<p>The number (#) should start with 1 and represents an index or unique ID for each contact. Once the contacts are printed out to the screen, the app should exit.</p>

<h4>Task 4: Contact details (<code>show</code> command)</h4>

<p>When on the user sends in the <code>show</code> command along with an id (index) of the contact, the app should display their details. If a contact with that index/id is found, display their details, with each field being printed on an individual line. If the contact cannot be found, display a custom &quot;not found&quot; message.</p>

<h4>Task 5: Implement Contact search (<code>find</code> command)</h4>

<p>After issuing the <code>find</code> command, along with a search term, the app will search through the names of the contacts and print the contact details of any contacts which have the search term contained within their name or email. (ie. the search term is a substring of the contact’s email or name)</p>

<p>Example use:</p>

<pre><code>ruby contact_list.rb find ted
</code></pre>

<h4>Task 6: Prevent duplicate entries</h4>

<p>If a user tries to input the exact contact with a the same email address twice, the app should output an error saying that the contact already exists and cannot be created. If you are asking for name first and then email, for a better user experience, it may make more sense to ask for their email first and then their name.</p>

<h4>Task 7: Multiple phone numbers</h4>

<p>When creating a contact implement the ability to add contact’s phone numbers. Contacts can have a limitless amount of phone numbers. Each phone number has a label and the number itself (eg: &quot;Mobile&quot; and &quot;444-555-3123&quot;). <strong>Challenge:</strong> How would you represent this label/data value in one CSV cell and display it properly?</p>

<h3>BONUS TASKS</h3>

<h4>Bonus Task 1: Make it executable!</h4>

<p>You can make your <code>contact_list.rb</code> file run just like a command-line app from Linux/Unix. This involves the use of two modifications. Here are some key terms that you should Google to accomplish this:</p>

<ul>
<li>Shebang (No, not the Ricky Martin song!)</li>
<li>Making shell scripts executable</li>
</ul>

<p>When this is done, you should be able to do the following from the command line:</p>

<pre><code>    ./contact_list find ted
</code></pre>

<p>And it will run and produce the correct output. </p>

<h4>Bonus Task 2: Pagination</h4>

<p>Whenever outputting contacts, display 5 and then prompt for the space key before printing another 5.</p>

<h4>Bonus Task 3: OOP++</h4>

<p>If you haven&#39;t already done so, think about breaking each command/operation that a user can do into its own class. </p>

<p>The Application class can just invoke the appropriate action by initializing that class and calling a <code>run</code> method on it. </p>

<p>What are the benefits to doing this? Can all of these classes inherit from a parent class? What do they all have in common? </p>
</div></section></div></main></body></html>
