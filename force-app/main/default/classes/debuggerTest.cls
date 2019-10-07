@istest
public class debuggerTest {
    static List<account> accounts = new List<account>();
    static List<debugger__c> lines = new List<debugger__c>();

    static debugger debug = new debugger();

    private static void factoryData (integer count) {
        for (integer i =0; i < count; i++) {
            Account a = new account(name='test ' + i);
            accounts.add(a);
        }
    }

    testmethod static void test () {
        factoryData(1);
        debug.timeStamp();
        insert accounts;
        debug.timeStamp();
        long timeSpan = debug.timespan();
        system.debug('timeSpan: ' + timeSpan);
        debug.timeSpan(true);

        for (account a: accounts) {
            debug.log(a.name);
            debug.log(a.name, true);
            system.debug('a.name: ' + a.name);
        }

        debug.writeLogs();
        
        lines = debug.getLogLines();
        
        system.debug('lines[1].textAreaLog__c: ' + lines[1].textAreaLog__c);
        system.assertEquals('test 0', lines[1].textAreaLog__c);
        system.assertEquals(3, lines.size());

    }

    testmethod static void test2 () {
        accounts.clear();
        factoryData(3000);
        for (account a: accounts) {
            debug.log(a.name);
        }
        debug.writeLogs();
        
        system.debug('***1***');
        for (debugger__c line : debug.getLogLines()) {
            system.debug('line.textAreaLog__c: ' + line.textAreaLog__c);
            system.debug('line.texAreaLongLog__c: ' + line.textAreaLongLog__c);
            system.debug('line.timeLog__c: ' + line.timeLog__c);
            system.debug('line.dateLog__c: ' + line.dateLog__c);
            system.debug('line.datetimeLog__c: ' + line.datetimeLog__c);
        }
    }

    testmethod static void test3 () {
        debug.overrideTesting(true);
        debug.log('koda');
        debug.writeLogs();
        lines = debug.getLogLines();

        system.debug('***2***');
        for (debugger__c line : lines) {
            system.debug('line.textAreaLog__c: ' + line.textAreaLog__c);
            system.debug('line.texAreaLongLog__c: ' + line.textAreaLongLog__c);
            system.debug('line.timeLog__c: ' + line.timeLog__c);
            system.debug('line.dateLog__c: ' + line.dateLog__c);
            system.debug('line.datetimeLog__c: ' + line.datetimeLog__c);
        }

        debug.overrideTesting(false);
        debug.log('koda');
        debug.writeLogs();
        Lines.clear();
        lines = debug.getLogLines();

        system.debug('***2.1***');
        for (debugger__c line : lines) {
            system.debug('line.textAreaLog__c: ' + line.textAreaLog__c);
            system.debug('line.texAreaLongLog__c: ' + line.textAreaLongLog__c);
            system.debug('line.timeLog__c: ' + line.timeLog__c);
            system.debug('line.dateLog__c: ' + line.dateLog__c);
            system.debug('line.datetimeLog__c: ' + line.datetimeLog__c);
        }
    }

    testmethod static void test4 () {
        system.debug('1');
        debug.log('norma', false, false, false,true);
        system.debug('1');
        debug.writeLogs();
        lines.clear();
        lines = debug.getLoglines();
        system.debug('***3***');
        for (debugger__c line : lines) {
            system.debug('line.textAreaLog__c: ' + line.textAreaLog__c);
            system.debug('line.texAreaLongLog__c: ' + line.textAreaLongLog__c);
            system.debug('line.timeLog__c: ' + line.timeLog__c);
            system.debug('line.dateLog__c: ' + line.dateLog__c);
            system.debug('line.datetimeLog__c: ' + line.datetimeLog__c);
        }

        debug.throwExeption(true);
        debug.log('test');
        debug.throwExeption(false);
        debug.overrideTesting(false);
        accounts.clear();
        factoryData(200);
        insert accounts;
        for (account a : accounts) {
            debug.log('account name: ' + a.name);
        }
        system.debug('***4***');
        debug.writeLogs();
        lines.clear();
        lines = debug.getLogLines();
        for (debugger__c line : lines) {
            system.debug('line.textAreaLog__c: ' + line.textAreaLog__c);
            system.debug('line.texAreaLongLog__c: ' + line.textAreaLongLog__c);
            system.debug('line.timeLog__c: ' + line.timeLog__c);
            system.debug('line.dateLog__c: ' + line.dateLog__c);
            system.debug('line.datetimeLog__c: ' + line.datetimeLog__c);
        }

        debug.timeSpan(true);
        debug.overrideTesting(true);
        debug.isAvailable();
    }

    testmethod static void test5() {
        factoryData(100);
        for (account a : accounts) {
            debug.log(a);
        }
        debug.writeLogs();
    }

    testmethod static void recordRowLimittest() {

        integer rows = LIMITS.getLimitDmlRows() - LIMITS.getDmlRows();
        rows=5000;
        system.debug('rows: rows');        
        factoryData(rows);
        for (account a : accounts) {
            debug.log(a);
        }
        debug.writeLogs();
        lines = debug.getLogLines();
        for (debugger__c line : lines) {
            system.debug('line.textAreaLog__c: ' + line.textAreaLog__c);
            system.debug('line.texAreaLongLog__c: ' + line.textAreaLongLog__c);
            system.debug('line.timeLog__c: ' + line.timeLog__c);
            system.debug('line.dateLog__c: ' + line.dateLog__c);
            system.debug('line.datetimeLog__c: ' + line.datetimeLog__c);
        }
    }
}
