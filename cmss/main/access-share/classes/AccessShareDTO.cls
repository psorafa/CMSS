public class AccessShareDTO {
    public User userToShareWith;
    public String reason;
    public Datetime expirationDate;
    public Id accountIdToShare;
    public Id roleId;

    public class remove{
        public Id userId;
        public Id accountId;
        public String reason;
        public AccountShare accountShare;
        public Boolean isManual;
        public Boolean toBeDeleted;
    }
}