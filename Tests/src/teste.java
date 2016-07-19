
public class teste {
	public static void main(String [] args) throws Exception{

		System.out.println(System.getProperty("java.version"));
		
		for (int i = 0; i < 100; ++i)
			for(int j = 0; j < 100; ++j)
				for(int k = 0; k < 100; ++k)
					for(int l = 0; l < 25; ++l)
						//for(int m = 0; m < 1000; ++m)
							System.out.println (i + j + k + l);
		Thread.sleep(10000);
	}
}
