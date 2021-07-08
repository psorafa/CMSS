public class AccessShareDao {

    public static List<AccessShare__c> getAllRecordsFromAccessShare() {
        return [SELECT AccessTo__c, CreatedById, CreatedDate, ExpirationDate__c,
        IsDeleted, LastModifiedById, LastModifiedDate, Name, Reason__c, RequestedBy__c, StartDate__c, SystemModstamp, Type__c
        FROM AccessShare__c];
    }

    public static List<AccessShare__c> getAllNonExpiredRecordsFromAccessShare() {
        return [SELECT AccessTo__c, CreatedById, CreatedDate, ExpirationDate__c, IsDeleted, LastModifiedById, LastModifiedDate,
        Name, Reason__c, RequestedBy__c, StartDate__c, SystemModstamp, Type__c
        FROM AccessShare__c
        WHERE ExpirationDate__c > :datetime.now().date()];
    }

    public static List<AccessShare__c> getAllNonExpiredRecordsFromAccessShareByRequestedByIdsAndType(Set<Id> requestedByIds, String typeAccSh) {
        return [SELECT AccessTo__c, CreatedById, CreatedDate, ExpirationDate__c, IsDeleted, LastModifiedById, LastModifiedDate,
        Name, Reason__c, RequestedBy__c, StartDate__c, SystemModstamp, Type__c
        FROM AccessShare__c
        WHERE ExpirationDate__c >= :date.today()
        AND RequestedBy__c IN : requestedByIds
        AND Type__c =: typeAccSh];
    }

    public static List<AccessShare__c> getAllExpiredRecordsFromAccessShare() {
        return [SELECT AccessTo__c, CreatedById, CreatedDate, ExpirationDate__c, IsDeleted, LastModifiedById, LastModifiedDate,
        Name, Reason__c, RequestedBy__c, StartDate__c, SystemModstamp, Type__c
        FROM AccessShare__c
        WHERE ExpirationDate__c <:datetime.now().date() OR ExpirationDate__c =:datetime.now().date()];
    }

    public static List<AccessShare__c> getAccessShareByUserIdAndRecordId(Id userId, Id recordId) {
        return [SELECT RequestedBy__c, AccessTo__c, Type__c
        FROM AccessShare__c
        WHERE AccessTo__c =:recordId AND RequestedBy__c =:userId];
    }

    public static List<AccessShare__c> getAccessShareByUserIdsAndRecordIds(Set<Id> userIds, Set<Id> recordIds) {
        return [SELECT RequestedBy__c, AccessTo__c, ExpirationDate__c, Type__c
        FROM AccessShare__c
        WHERE AccessTo__c IN :recordIds AND RequestedBy__c IN :userIds];
    }

    public static List<AccessShare__c> getAccessShareByUserIdAndRecordIdAndType(Id userId, Id recordId, String type) {
        return [SELECT RequestedBy__c, AccessTo__c, Type__c
        FROM AccessShare__c
        WHERE AccessTo__c =:recordId AND RequestedBy__c =:userId AND Type__c =:type];
    }

    public static List<AccessShare__c> getAccessShareByUserIdsAndRecordIdAndType(Set<Id> userIds,
                                                                                   Id recordId,
                                                                                   String typeAccSh) {
        return [SELECT RequestedBy__c, AccessTo__c, Type__c
        FROM AccessShare__c
        WHERE AccessTo__c =:recordId AND RequestedBy__c IN :userIds AND Type__c =:typeAccSh];
    }

    public static List<AccessShare__c> getAccessShareByRecordIdsAndType(Set<Id> recordIds, String typeAccSh) {
        return [SELECT RequestedBy__c, AccessTo__c, Type__c
        FROM AccessShare__c
        WHERE AccessTo__c IN :recordIds AND Type__c =:typeAccSh];
    }

    public static List<AccessShare__c> getNonExpiredAccessShareByRecordIdsAndType(Set<Id> recordIds, String typeAccSh) {
        return [SELECT RequestedBy__c, AccessTo__c, Type__c
        FROM AccessShare__c
        WHERE AccessTo__c IN :recordIds AND Type__c =:typeAccSh AND ExpirationDate__c >=: Date.today()];
    }

    public static List<AccessShare__c> getNonExpiredAccessShareByRecordIdsAndRequestedByAndType(Set<Id> recordIds, Set<Id> userIds, String typeAccSh) {
        return [SELECT RequestedBy__c, AccessTo__c, Type__c
        FROM AccessShare__c
        WHERE AccessTo__c IN :recordIds AND RequestedBy__c IN : userIds AND Type__c =:typeAccSh AND ExpirationDate__c >=: Date.today() ORDER BY StartDate__c DESC];
    }

    public static List<AccessShare__c> getAccessShareByRecordId(Id recordId) {
        return [SELECT RequestedBy__c, AccessTo__c, Type__c, Reason__c
        FROM AccessShare__c
        WHERE AccessTo__c =:recordId];
    }

    public static List<AccessShare__c> getAccessShareByUserAndAccountIds(Set<Id> userIds, Set<Id> accountIds) {
        return [
            SELECT AccessTo__c, CreatedById, CreatedDate, ExpirationDate__c, IsDeleted, LastModifiedById, LastModifiedDate, Name, Reason__c,
                RequestedBy__c, StartDate__c, SystemModstamp, Type__c
            FROM AccessShare__c
            WHERE RequestedBy__c IN: userIds AND AccessTo__c IN: accountIds
        ];
    }

    public static List<AccessShare__c> getAccessShareByAccountIds(Set<Id> accountIds) {
        return [
            SELECT AccessTo__c, CreatedById, CreatedDate, ExpirationDate__c, IsDeleted, LastModifiedById, LastModifiedDate, Name, Reason__c,
                RequestedBy__c, StartDate__c, SystemModstamp, Type__c
            FROM AccessShare__c
            WHERE AccessTo__c IN: accountIds
        ];
    }

    public static List<AccessShare__c> getAccessShareByUserIds(Set<Id> userIds) {
        return [SELECT AccessTo__c, CreatedById, CreatedDate, ExpirationDate__c, IsDeleted, LastModifiedById, LastModifiedDate, Name, Reason__c, RequestedBy__c, StartDate__c, SystemModstamp, Type__c
        FROM AccessShare__c
        WHERE RequestedBy__c IN :userIds];
    }

    public static List<AccessShare__c> getAccessShareByUserIdsAndAccoutnIds(Set<Id> userIds, Set<Id> accIds) {
        return [SELECT AccessTo__c, CreatedById, CreatedDate, ExpirationDate__c, IsDeleted, LastModifiedById, LastModifiedDate, Name, Reason__c, RequestedBy__c, StartDate__c, SystemModstamp, Type__c
        FROM AccessShare__c
        WHERE RequestedBy__c IN :userIds AND AccessTo__c IN :accIds];
    }

    public static List<AccessShare__c> getAccessShareByUserId(Id userId) {
        return [SELECT AccessTo__c, CreatedById, CreatedDate, ExpirationDate__c, IsDeleted, LastModifiedById, LastModifiedDate, Name, Reason__c, RequestedBy__c, StartDate__c, SystemModstamp, Type__c
        FROM AccessShare__c
        WHERE RequestedBy__c = :userId];
    }
    
    public static List<AccessShare__c> getAccessShareByUserIdAndAccoutnIds(Id userIds, Set<Id> accIds) {
        return [SELECT AccessTo__c, ExpirationDate__c, Reason__c, RequestedBy__c, Type__c
        FROM AccessShare__c
        WHERE RequestedBy__c = :userIds AND AccessTo__c IN :accIds];
    }
}