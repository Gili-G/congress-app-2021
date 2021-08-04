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
import java.util.List;

public class Main {
    Bucket bucket = StorageClient.getInstance().bucket();
    public static void main(String[] args) throws IOException, InterruptedException {
        Init();

        List<String> listArgs = new ArrayList<>();
        listArgs.add("python");
        listArgs.add("detection_small.py");
        Process p = new ProcessBuilder()
                .directory(new File("./pyprocessing-small/object_detection/"))
                .command(listArgs)
                .inheritIO()
                .redirectErrorStream(true)
                .start();

        Thread printingHook = new Thread(() -> p.destroy());
        Runtime.getRuntime().addShutdownHook(printingHook);

        BufferedReader pyResults = new BufferedReader(new InputStreamReader(p.getErrorStream()));
        while(true) {
            System.out.println(pyResults.readLine());
            Thread.sleep(100);
        }
//        for (String s = pyResults.readLine(); !(s != null && s.equals("beginValues")); s = pyResults.readLine()) {
//            System.out.println("S is:" + s);
//            Thread.sleep(100);
//        }
//
//        List<Float> rollingAvg = new ArrayList<>(5);
//        while(true) {
//            float num = Float.parseFloat(pyResults.readLine());
//            rollingAvg.add(0, num);
//            rollingAvg.remove(rollingAvg.size() - 1);
//            System.out.println(rollingAvg);
//            Thread.sleep(100);
//        }
    }

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