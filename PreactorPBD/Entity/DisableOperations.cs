internal struct DisableOperations
{
    public DisableOperations(int idRout, int KTOP)
    {
        IdRout = idRout;
        this.KTOP = KTOP;
    }
    public  int IdRout { get; set; }
    public  int KTOP { get; set; }
}