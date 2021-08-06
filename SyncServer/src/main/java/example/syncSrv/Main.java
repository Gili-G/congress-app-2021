package example.syncSrv;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.storage.Bucket;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.StorageClient;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Main {
    Bucket bucket = StorageClient.getInstance().bucket();
    public static void main(String[] args) throws IOException, InterruptedException {
        System.out.println("Initing GCloud stuff");
        Init();
//        //todo figure out
//        Thread printingHook = new Thread(() -> p.destroy());
//        Runtime.getRuntime().addShutdownHook(printingHook);

        System.out.println("Starting process");
        List<String> listArgs = new ArrayList<>();
        listArgs.add("python");
        listArgs.add("./detection_small.py");
        //listArgs.add("C:\\Users\\ADMIN\\IdeaProjects\\congress-app-2021\\pyprocessing-small\\object_detection\\print_test.py");
        Process p = new ProcessBuilder()
                .directory(new File("./pyprocessing-small/object_detection/"))
                .command(listArgs)
                //.inheritIO()
                .redirectErrorStream(true)
                .start();

        System.out.println("Begin reading!");
        BufferedReader pyResults = new BufferedReader(new InputStreamReader(p.getInputStream()));
        while(!pyResults.readLine().contains("OUTVAL")) {
//            String s = pyResults.readLine();
//            if(s != null) System.out.println("Reader:" + s);
            Thread.sleep(100);
        }
//        for (String s = pyResults.readLine(); !(s != null && s.equals("beginValues")); s = pyResults.readLine()) {
//            System.out.println("S is:" + s);
//            Thread.sleep(100);
//        }
//
        List<Double> rollingAvg = new ArrayList<>(Arrays.asList(0.0, 0.0, 0.0, 0.0, 0.0));
        String lin;
        while((lin = pyResults.readLine()) != null) {
            Double num = Double.parseDouble(lin.substring(6));
            rollingAvg.add(0, num);
            rollingAvg.remove(rollingAvg.size() - 1);
            float total = 0;
            for(Double d: rollingAvg) {
                total += d;
            }
            System.out.println(total / 5);
            System.out.println(rollingAvg);
            Thread.sleep(100);
        }
    }

//    public static String getNext(BufferedReader r) throws IOException {
//        String returnable = r.readLine();
//        String change;
//        while((change = r.readLine()) != null) {
//            returnable = change;
//        }
//        return returnable;
//    }

    //turns a dir path to a byte array. Must be a jpg
    public static byte[] pathToByeArr(String path) throws IOException {
        BufferedImage bImage = ImageIO.read(new File(path));
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        ImageIO.write(bImage, "jpg", bos);
        return bos.toByteArray();
    }

    //sets up firebase app
    public static void Init() {
        FileInputStream account = null;
        try {
            account = new FileInputStream("./SyncServer/congress-app-c6d54-firebase-adminsdk-l84cs-e41c97bcf7.json");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        FirebaseOptions options = null;
        try {
            options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(account))
                    .setStorageBucket("congress-app-c6d54.appspot.com")
                    .build();
        } catch (IOException exception) {
            exception.printStackTrace();
        }
        FirebaseApp.initializeApp(options);
    }

    public static Mono<?> runLearning() {
        return Mono.just("");
//        return Mono.fromRunnable(() -> {
//            try {
//                new ProcessBuilder()
//                        .inheritIO() //for debugging this prints all the output into the console
//                        .command("todo")
//                        .start()
//                        .waitFor();
//            } catch (InterruptedException | IOException e) {
//                e.printStackTrace();
//            }
//        });
    }
}