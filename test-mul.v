/* ACM Class System (I) Fall Assignment 1 
 *
 *
 * This file is used to test your adder. 
 * Please DO NOT modify this file.
 * 
 * GUIDE:
 *   1. Create a RTL project in Vivado
 *   2. Put `adder.v' OR `adder2.v' into `Sources', DO NOT add both of them at the same time.
 *   3. Put this file into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */

`include "wallace-mul.v"

module test_mul;
	wire signed [31:0] answer;
	reg signed [15:0] a, b;
	reg	signed [31:0] res;

	multiplier multi (a, b, answer);
	
	integer i, j = 0;
	initial begin
		for(i=1; i<=100; i=i+1) begin
			a[15:0] = $random;
			b[15:0] = $random;
            // a[15] = 0; b[15] = 0;
			res		= a * b;
			
			#10000;
			$display("TESTCASE %d: %d * %d = %d", i, a, b, answer);

			if (answer !== res[31:0]) begin
				$display("Wrong Answer!");
                j = 1;
			end

            #10000;
		end
		$display("Correct: 0, Incorrect: 1: %d", j);
		$finish;
	end
endmodule