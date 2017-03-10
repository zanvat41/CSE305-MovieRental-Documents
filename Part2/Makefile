

cs: clean_sql

clean_sql: remove_tab_characters

remove_tab_characters:
	# Replaces tab characters with space characters for easier copy/pasting into MySQL
	cp -f code/Schema.sql temp/Schema.sql
	cp -f code/Triggers.sql temp/Triggers.sql
	sed -i 's/\t/ /g' temp/Schema.sql temp/Triggers.sql
