import 'package:flutter/material.dart';
import 'appTextStyles.dart'; // 원하는 글꼴 스타일이 정의된 파일을 임포트
import 'appColors.dart'; // 색상 정의 파일을 임포트
import 'gaps.dart';

void main() {
  runApp(MaterialApp(
    title: 'First App',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: MedicineDetailPage(),
  ));
}

class MedicineDetailPage extends StatefulWidget {
  const MedicineDetailPage({super.key});

  @override
  _MedicineDetailPageState createState() => _MedicineDetailPageState();
}

class _MedicineDetailPageState extends State<MedicineDetailPage> {
  bool showWarning = true; // 초기에는 주의사항을 보이게 설정
  bool isFavorite = false; // 즐겨찾기 상태

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 뒤로 가기 버튼의 동작을 정의합니다.
          },
        ),
        title: Text('대웅바이오니세르골린정30밀리그램', style: AppTextStyles.body1S16),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/rect.png', // 약 이미지 파일 경로
                fit: BoxFit.cover,
              ),
              Positioned(
                right: 8.0,
                bottom: 8.0,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite ? AppColors.vibrantTeal : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Text(
            '대웅바이오(주)',
            style:
                AppTextStyles.body3S15.copyWith(color: AppColors.vibrantTeal),
          ),
          const SizedBox(height: 8.0),
          Text(
            '대웅바이오니세르골린정30밀리그램',
            style: AppTextStyles.title2B20,
          ),
          const SizedBox(height: 8.0),
          Visibility(
            visible: showWarning,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.gr100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.yellow),
                  const SizedBox(width: 8.0),
                  Text(
                    '000님의 질병에서 주의해야하는 약이에요',
                    style: AppTextStyles.body5M14.copyWith(color: AppColors.bk),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            '성분',
            style: AppTextStyles.body4S14,
          ),
          Gaps.h4,
          Text(
            '기립용기, 실온( 30°C)이하보관',
            style: AppTextStyles.body5M14,
          ),
          Gaps.h20,
          Text(
            '효능효과',
            style: AppTextStyles.body4S14,
          ),
          Gaps.h4,
          Text(
            '5, 10 mg\n'
            '뇌경색 후유증에 수반되는 만성뇌순환장애에 의한 외우지 하의 개선\n'
            '노인성 우울정상성 두통\n'
            '고혈압의 보조요법\n'
            '30 mg\n'
            '임차성 뒤행성 현관재 및 복합성천재약 판단력 다음 치 매증후군의 현저한 저하: 기억력 손상, 집중력장애, 판단력 장애, 자극성 부족',
            style: AppTextStyles.body5M14,
          ),
          Gaps.h20,
          Text(
            '용법용량',
            style: AppTextStyles.body4S14,
          ),
          Gaps.h4,
          Text(
            '성인: 니세르골린으로서 1일 5 mg을 1일 2회 성미에 공복유여다 6개월간 섭취다.',
            style: AppTextStyles.body5M14,
          ),
          Gaps.h20,
          Text(
            '주의사항',
            style: AppTextStyles.body4S14,
          ),
          Gaps.h4,
          Text(
            '1. 다음 환자에게는 투여하지 말 것.\n'
            '2. 이 약 또는 이약의 성분에 과민반응 환자\n'
            '3. 심한 신장애 환자\n'
            '4. 급성 혼돈 환자\n'
            '5. 교감신경흥분약을 투여받고 있는 환자\n'
            '6. 협찮한 서맥 환자(< 50 회/분)\n'
            '7. 두개내출혈 후 치유가 끝나지 않은 환자\n'
            '8. 기타금속정의 환자\n'
            '9. 다음 환자에는 신중히 투여할 것.\n'
            '10. 경증의 신장애 환자\n'
            '11. 신기능장애 환자\n'
            '12. 이상반응\n'
            '13. 소화기계: 드물게 식욕부진, 설사, 변비, 구역, 구토, 산재 성 불쾌법등 복통, 구갈 등이 나타날 수 있다.\n'
            '14. 간장: 드물게 ALT, AST 상승 등이 나타날 수 있다.\n'
            '15. 순환기계: 드물게 이차질, 기립저혈장애, 고혈압, 혈관운 성 신충, 혈압강하 등이 나타날 수 있다.\n'
            '16. 정신신경계: 드물게 졸음, 걸거림, 두통, 어지럼, 피로, 불면 증이 나타날 수 있다.\n'
            '17. 과민반응: 드물게 발진, 두드러기, 가려움, 홍조, 열감 등이 나타날 수 있다.',
            style: AppTextStyles.body5M14,
          ),
        ],
      ),
    );
  }
}
