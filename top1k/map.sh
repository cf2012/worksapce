# mkdir ss
# cd ss && time split -l10000000 ../all.data.txt
# time sh map.sh


for x in `ls -1 ss/`
do
	python tp1k.py ss/$x > $x.tp1k.out &
done
wait

