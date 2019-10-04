@istest
public class debuggerTest {
    static List<account> accounts = new List<account>();
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
        }
        debug.stopLogging();
        List<debugger__c> lines = debug.lines;
        
        system.debug('***1***');
        for (debugger__c line : lines) {
            system.debug('line.textAreaLog__c: ' + line.textAreaLog__c);
            system.debug('line.texAreaLongLog__c: ' + line.textAreaLongLog__c);
            system.debug('line.timeLog__c: ' + line.timeLog__c);
            system.debug('line.dateLog__c: ' + line.dateLog__c);
            system.debug('line.datetimeLog__c: ' + line.datetimeLog__c);
        }

        lines = debug.lines;
        debug.stopLogging();
        debug.overrideTesting(true);
        debug.log('koda');

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
        debug.stopLogging();

        system.debug('***2.1***');
        for (debugger__c line : lines) {
            system.debug('line.textAreaLog__c: ' + line.textAreaLog__c);
            system.debug('line.texAreaLongLog__c: ' + line.textAreaLongLog__c);
            system.debug('line.timeLog__c: ' + line.timeLog__c);
            system.debug('line.dateLog__c: ' + line.dateLog__c);
            system.debug('line.datetimeLog__c: ' + line.datetimeLog__c);
        }
        system.debug('1');
        debug.log('norma', false, false, false,true);
        system.debug('1');
        debug.stopLogging();
        lines = debug.lines;
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
        debug.stopLogging();
        system.debug('***4***');
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
}
