OUT=output.sql
MnA="01_MySQL_Movies&Actors.sql"
AnO="01_MySQL_Accounts&Orders.sql"
TRIG=01_MySQL_Triggers.sql
INS=test.sql

all: erase movies_and_actors accounts_and_orders triggers inserts get clean

all_no_insert: erase movies_and_actors accounts_and_orders triggers get clean

all_no_test: erase movies_and_actors accounts_and_orders get clean

all_keep: erase movies_and_actors accounts_and_orders triggers inserts get

all_no_copy: erase movies_and_actors accounts_and_orders triggers inserts remove_tabs_from_output_file

movies_and_actors:
	cat ../code/$(MnA) >> $(OUT)

accounts_and_orders:
	cat ../code/$(AnO) >> $(OUT)

triggers:
	cat ../code/$(TRIG) >> $(OUT)

inserts:
	cat $(INS) >> $(OUT)

movies_and_actors_only:
	cat ../code/$(MnA) > $(OUT)

accounts_and_orders_only:
	cat ../code/$(AnO) > $(OUT)

triggers_only:
	cat ../code/$(TRIG) > $(OUT)

inserts_only:
	cat $(INS) > $(OUT)

remove_tabs_from_output_file:
	tr '\t' ' ' < $(OUT) > $(OUT)_tmp
	mv -f $(OUT)_tmp $(OUT)

get: remove_tabs_from_output_file
	tr '\t' ' ' < $(OUT) | xclip -sel clip

erase:
	> $(OUT)

clean:
	rm -f $(OUT) $(OUT)_tmp
