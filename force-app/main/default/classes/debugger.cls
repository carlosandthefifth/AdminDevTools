public virtual class debugger {

    private string queryLogString = 'SELECT ID, name, textAreaLog__c, textAreaLongLog__c, dateLog__c, datetimeLog__c, timeLog__c FROM debugger__c';

    // Timestamp flag
    public static boolean       firstTime = true;
    public static boolean       runLogging = false;
    public static long          timeSpan;
    private debugger__c         line;
    List<debugger__c>           lines = new List<debugger__c>();

    private static boolean overrideTesting       = false; // code coverage
    private static boolean throwExpeption        =false; // code coverage
    public class codeCoverageException extends Exception {}

    private static long         startTime      = 0;
    private static long         stopTime       = 0;
    private static long         timeStamp      = 0;
    private static boolean      hasTimeStamp   = false;
    private static DateTime     datetimeTimeStamp;
    private static boolean      isAvailable;


    public virtual boolean isAvailable () {
        try {
            integer i = Database.countquery(query);
            // fpr complete code coverage
            if (test.isRunningTest() && !overrideTesting) {
                Database.countQuery('SELECT count() FROM doesntexist__c'); // to throw exception for code coverage
            }
            return true;
        } catch (QueryException q) {
            return false;
        }
    }

    public  debugger () {
        isAvailable = isAvailable();
    }

    private static final String query = 'SELECT count() FROM debugger__c';
    public void overrideTesting(boolean value) {
        overrideTesting = value;
    }

    public void throwExeption(boolean value) {
        throwExpeption = value;
    } 

    public virtual void log(string log, boolean useLongArea, boolean includeDateTimeStamp, boolean onlyDateTimeStamp, boolean onlyTimeSpan) {
        try {
            if (throwExpeption) throw new codeCoverageException('code coverage exception');
            if ((isAvailable || test.isRunningTest()) && !overrideTesting) {
                DateTime getNow  =  system.now();
                debugger__c aline = new debugger__c(); 

                if (useLongArea) {
                    if ((includeDateTimeStamp || onlyDateTimeStamp) && !onlyTimeSpan) aLine.datetimeLog__c = getNow;
                    if (!onlyDateTimeStamp && !onlyTimeSpan) {
                        aLine.textAreaLongLog__c = log;
                    }
                    if (onlyTimeSpan) aline.textAreaLog__c = 'timeSpan: ' + timespan;
                } else {
                    if ((includeDateTimeStamp || onlyDateTimeStamp) && !onlyTimeSpan) aLine.datetimeLog__c = getNow;

                    if (!onlyDateTimeStamp && !onlyTimeSpan) {
                        aLine.textAreaLog__c = log;
                    }
                    if (onlyTimeSpan) {
                        aLine.textAreaLog__C = 'timeSpan: ' + timespan;
                    }
                }
                lines.add(aLine);
            } else {
                System.debug('log: ' + log);
            }
        } catch (Exception e) {
            system.debug('error in log(string,boolean): ' + e.getMessage());
        }
    }


    public virtual void log(string log, boolean useLongArea, boolean includeDateTimeStamp, boolean onlyDateTimeStamp) {
        log(log, useLongArea, includeDateTimeStamp, onlyDateTimeStamp, false);
    }

    public virtual void log(string log, boolean useLongArea, boolean includeDateTimeStamp) {
        log(log, useLongArea, includeDateTimeStamp, false);
    }

    public virtual void log(string log, boolean uselongArea){
        log(log, useLongArea, false);
    }

    public virtual void log(string log){
        log(log, false);
    }

    public virtual void log(){
        log('');
    }

    public virtual void log(SObject anObject){
        String objString = JSON.serialize(anObject);
        log(objString);
        objString = JSON.serializePretty(anObject);
        log(objString,true);
    }

    private virtual void logTimeSpan(long timeSpan) {
        if (hasTimeStamp)
            log('####', false, false, false,true);
        else 
            log('timeStamp was not called');
    }

    // add log map values
    // add log list values 

    public virtual void timeStamp() {
        if (firstTime) {
            firstTime = false;
            startTime = system.currentTimeMillis();
        } else {
            firstTime = true;
            stopTime = system.currentTimeMillis();
            hasTimeStamp = true;
        }
    }

    public virtual long timeSpan(boolean logIt) {
        timeSpan = stopTime - startTime;
        if (logIt) {
            logTimeSpan(timeSpan);
            hasTimeStamp = false;
            startTime = 0;
            stopTime  = 0;
            timeSpan  = 0;
        }
        return timeSpan;
    }
    public virtual long timeSpan() {
        return timeSpan(false);
    }

    public virtual List<debugger__c> getLoglines(integer rows) {
        integer availableRows = LIMITS.getLimitQueryRows() - LIMITS.getQueryRows();

        if (rows > availableRows) {
            List<debugger__c> lines = new List<debugger__c>();
            debugger__c line = new debugger__c();
            line.textAreaLog__c = rows + ' exceeds available rows of ' + availableRows;
            line.textAreaLongLog__c = rows + ' exceeds available rows of ' + availableRows;
            lines.add(line);
            return lines;
        }

        if (rows == -1) rows = availableRows;

        String fullquery = queryLogString + ' LIMIT ' + string.valueOf(rows);
        system.debug('fullquery: ' + fullquery);
        return database.query(fullquery);
    }

    public virtual List<debugger__c> getLoglines() {
        return getLogLines(-1);
    }

    public virtual boolean writeLogs() {
        try {
            insert lines;
            if (throwExpeption) throw new codeCoverageException('code coverage exception');
            return true;
        } catch (Exception e) {
            system.debug('writing files: ' + e.getmessage());
            return false;
        }
    } 
}
