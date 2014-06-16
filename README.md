watchman
========

Sends email if any of the watched files are modified.

After you clone this project, setup watchman in Cron like below.

````shell
*/60 * * * * cd /watchman-dir/ && $(which ruby) watchman.rb
````
