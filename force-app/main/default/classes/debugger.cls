public virtual class debugger {

    // Timestamp flag
    public static boolean       firstTime = true;
    public static boolean       runLogging = false;
    public static long          timeSpan;
    public List<debugger__c>    lines;
    

    private static boolean overrideTesting       = false; // code coverage
    private static boolean throwExpeption        =false; // code coverage
    public class codeCoverageException extends Exception {}

    private static boolean      loggingStarted = false;
    private static boolean      stopLogging    = false;
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


    public virtual void stopLogging() {
        stopLogging = true;
        log();
    }


    public virtual void log(string log, boolean useLongArea, boolean includeDateTimeStamp, boolean onlyDateTimeStamp, boolean onlyTimeSpan) {
        if (!loggingStarted) {
            
            loggingStarted = true;
            if (lines == null)
                lines = new List<debugger__c>();
            else 
                lines.clear();
        } else if (stopLogging) {
            insert lines;
            loggingStarted = false;
            runLogging    = false;
            stopLogging   = false;
        }
        try {
            if (throwExpeption) throw new codeCoverageException('code coverage exception');
            if ((isAvailable || test.isRunningTest()) && !overrideTesting) {
                DateTime getNow  =  system.now();
                debugger__c aline = new debugger__c(); 

                if (useLongArea) {
                    if ((includeDateTimeStamp || onlyDateTimeStamp) && !onlyTimeSpan) aLine.datetimeLog__c = getNow;
                    if (!onlyDateTimeStamp && !onlyTimeSpan) {
                        aLine.textAreaLongLog__c = log;
                        lines.add(aLine);
                    }
                    if (onlyTimeSpan) aline.textAreaLog__c = 'timeSpan: ' + timespan;
                } else {
                    if ((includeDateTimeStamp || onlyDateTimeStamp) && !onlyTimeSpan) aLine.datetimeLog__c = getNow;

                    if (!onlyDateTimeStamp && !onlyTimeSpan) {
                        aLine.textAreaLog__c = log;
                        lines.add(aLine);
                    }
                    if (onlyTimeSpan) {
                        aLine.textAreaLog__C = 'timeSpan: ' + timespan;
                        lines.add(aLine);
                    }
                }
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
}
