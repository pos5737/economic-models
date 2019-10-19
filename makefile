
all: data/economic-models.csv example.png README.md

# full dataset
data/economic-models.csv: R/join-data.R intermediate-data/rdi.csv intermediate-data/gdp.csv intermediate-data/unemp.csv intermediate-data/election.csv
	Rscript $<
	
# render README
README.md: README.Rmd
	Rscript -e 'rmarkdown::render("$<")'		
	rm -f README.html
	
# example figure
example.png: R/make-figure.R
	Rscript $<
	rm -f Rplots.pdf

# rdi
intermediate-data/rdi.csv: R/get-rdi-data.R
	Rscript $<
	
# gdp
intermediate-data/gdp.csv: R/get-gdp-data.R
	Rscript $<
	
# unemployment
intermediate-data/unemp.csv: R/get-unemp-data.R
	Rscript $<	
	
# election results
intermediate-data/election.csv: R/get-election-data.R
	Rscript $<	

# clean
clean:
	rm -f README.md 
	rm -f example.png
	rm -f data/economic-models.csv
	rm -f intermediate-data/*
	rm -f raw-data/*