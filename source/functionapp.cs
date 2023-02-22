using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection;

[assembly: FunctionsStartup(typeof(MyFunctionApp.Startup))]

namespace MyFunctionApp
{
    public class Startup : FunctionsStartup
    {
        public override void Configure(IFunctionsHostBuilder builder)
        {
            builder.Services.AddScoped<IMyService, MyService>();
        }
    }

    public class MyFunction
    {
        private readonly IMyService _myService;

        public MyFunction(IMyService myService)
        {
            _myService = myService;
        }

        [FunctionName("MyFunction")]
        public async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            // call service
            await _myService.DoSomething();
            
            return new OkResult();
        }
    }

    public interface IMyService
    {
        Task DoSomething();
    }

    public class MyService : IMyService
    {
        public async Task DoSomething()
        {
            // print hello world
            Console.WriteLine("Hello World");
        }
    }
}
