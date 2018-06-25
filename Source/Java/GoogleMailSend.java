/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package googlemailsend;
// Needed for Properties
import java.util.*;

// Base libraries for emailing
import javax.mail.*;
import javax.mail.internet.*;

// Data handler
import javax.activation.*;

/**
 *
 * @author Doye
 * 
 */

// ----------------------------------------------------------- Examples followed and altered ---------------------------------------------------------------
// Tutorial for gmail STMP - https://www.mkyong.com/java/javamail-api-sending-email-via-gmail-smtp-example/
// MATLAB integration used from - https://www.mathworks.com/help/pdf_doc/matlab/apiext.pdf
// Google integration and message attachment - https://developers.google.com/gmail/api/guides/sending
// Google code examples were licensed under the Apache 2.0 License. Code used as a reference.
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

public class GoogleMailSend {

    /**
     * @param args the command line arguments
     */

    
    public static boolean Authentication(String sourceEmail, String password){
                        boolean success = true;
                        
        		Properties props = new Properties();
                
                // Parameters needed for gmail
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
                
		Session session = Session.getInstance(props,
		  new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(sourceEmail, password);
			}                 
		  });

                
                try{
                    Transport verify = session.getTransport("smtp");   
                    verify.connect(sourceEmail, password);
                    verify.close();
                    
                }
                catch(AuthenticationFailedException e){
                    success = false;
                    
                    return success;
                    
                }
                catch(MessagingException e){
                
                }
                return success;
    }
    
    public static void SendMail(String sourceEmail, String password, 
            String destination, String subject, String mainText, String inputPath){
        


		Properties props = new Properties();
                
                // Parameters needed for gmail
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");

                // Begin a session and get user/password
		Session session = Session.getInstance(props,
		  new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(sourceEmail, password);
			}
		  });

		try {
                        // Email to be sent from
                        String sender = sourceEmail;
                        
                        // Email to send to
                        String recipient = destination;
                        
                        // Being a new message using the session created earlier
			Message message = new MimeMessage(session);
                        
                        // Set who the email is from
			message.setFrom(new InternetAddress(sender));
                        
                        // Set who will recieve the email
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
                        
                        // Set the subject line
			message.setSubject(subject);
                        
                        
                        // Create a group of attatchments
                        MimeBodyPart messageBodyPart = new MimeBodyPart();
                        
                       // Set the main body of the email (multipart due to attachment)
			BodyPart content = new MimeBodyPart();
                        content.setText(mainText);
                        
                        // Create an attachment
                        Multipart attachment = new MimeMultipart();

                        // Attach the file using a file path and choose a name
                        messageBodyPart = new MimeBodyPart();
                        String file = inputPath;
                        String fileName = "Verification.png";
                        
                        // Use javax Data source to attach the file to the group
                        DataSource source = new FileDataSource(file);
                        messageBodyPart.setDataHandler(new DataHandler(source));
                        messageBodyPart.setFileName(fileName);
                        
                        attachment.addBodyPart(messageBodyPart);
                        attachment.addBodyPart(content);
                        
                        

                        // Attach the group to the email and send it
                        message.setContent(attachment);                        
			Transport.send(message);

                        // Print a small statement to confirm
			System.out.println("Email sent");

		} catch (MessagingException e) {
                    // Throw an exception if it fails
			throw new RuntimeException(e);
		}
    }
    
}
