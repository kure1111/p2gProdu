public class LineSplitter {

    public static final Integer DEFAULT_LINE_LENGTH = 70;

    public static final String NEW_LINE = '<br/>';

    public static String splitLines(String input, Integer lineLength) 
    {
        if (lineLength == null) 
       		lineLength = DEFAULT_LINE_LENGTH; 
        
        if (input == null || input.length() <= lineLength) 
            return (input == null ? '' : input);
        
        string respuesta = '';
        
          for (Integer i = 0; i < input.length(); i=i+lineLength)
            {
                Integer iEffectiveEnd = (i+lineLength) > input.length() ? input.length() : (i+lineLength);
                respuesta += input.substring(i,iEffectiveEnd) + ' ' + NEW_LINE; 
            }
        
        return respuesta;
    }


}