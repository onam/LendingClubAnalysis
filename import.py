#!/usr/bin/python
"""
A little script to parse up raw data from the Lending Club
"""

import os, sys, logging, re

logger = logging.getLogger(__name__)


sh = logging.StreamHandler()
sh.setLevel(logging.DEBUG)

# create formatter and add it to the handlers
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
sh.setFormatter(formatter)

logger.addHandler(sh)
logger.setLevel(logging.DEBUG)


def clean_line(line):
    """
    tries to handle invalid csv:
    "1","2","Some text with ""quoted junk"","3"
    """
    #This sucks.  May have to be a little more clever
    terms = ["Sam's Place",
             "hazardous waste",
             "space suits",
             "bad boy.",
             "sit",
             "stay",
             "tamers", "have", "The Lending Tree Loan site",
             "normal job", "excellent", "RISK", "Thank you", 
             "Regolith Excavation Challenge", "Red Team", "toys",
             "if you cant pay cash then dont buy it", "Gold Option Down"]

    for term in terms:
        line = line.replace("\"\"%s\"\""%term, "&quote;%s&quote"%term)
    
    return line

def main(toParse):
    """
    parses up the file
    """
    logger.info( 'Parsing %s'%toParse )

    f = open(toParse, 'r')

    section_num = 0
    row_num = 0
    col_cnt = 0
    #make it a proper csv    
    for line in f:
        row_num += 1
        if row_num == 1:
            continue
        if row_num == 2:
            #append the section number
            col_cnt = len(line.split(","))
            line += ",section_num"
            
            logger.debug("%s --> %d columns"%(line, col_cnt))
        else:
            line = clean_line(line)
            cols = len(line.split("\","))
            if cols != col_cnt:
                logger.debug(line)
                logger.info("Skipping row %d because it only has %d cols; not %d"%(row_num, cols, col_cnt))
                raise Exception()
        
    f.close()


if __name__ == "__main__":
    toParse = os.path.join(".", "data", "LoanStatsNew.csv")
    logger.debug("Have %d params"%len(sys.argv))
    if len(sys.argv) >= 2:
        toParse = sys.argv[1]
    main(toParse)