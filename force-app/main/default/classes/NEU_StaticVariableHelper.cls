public with sharing class NEU_StaticVariableHelper {
  private static boolean myboolean1 = false;
    public static boolean setBoolean1(boolean value) {
    boolean oldValue=myboolean1;
        myboolean1=value;
        return oldValue;
    }
    public static boolean getBoolean1() {
        return myboolean1;
    }
}